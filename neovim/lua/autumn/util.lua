local M = {}

function M.copysign(x, y)
    if y > 0 or (y == 0 and math.atan2(y, -1) > 0) then
        return math.abs(x)
    else
        return -math.abs(x)
    end
end

function M.round(x)
    local absx, y
    absx = math.abs(x)
    y = math.floor(absx)

    if absx - y >= 0.5 then
        y = y + 1.0
    end

    return M.copysign(y, x)
end


--- @param hex string
--- @return number red
--- @return number green
--- @return number blue
function M.hex_to_rgb(hex)
    local red = tonumber(hex:sub(2, 3), 16)
    local green = tonumber(hex:sub(4, 5), 16)
    local blue = tonumber(hex:sub(6, 7), 16)

    return red, green, blue
end

--- @param red number
--- @param green number
--- @param blue number
--- @return string color
function M.rgb_to_hex(red, green, blue)
    return string.format('#%02x%02x%02x', red, green, blue)
end

--- @param r number
--- @param g number
--- @param b number
--- @return number h
--- @return number s
--- @return number l
function M.rgb_to_hsl(r, g, b)
    r = r / 255
    g = g / 255
    b = b / 255

    -- Find the minimum and maximum values
    local min = math.min(r, g, b)
    local max = math.max(r, g, b)

    -- Calculate luminance (L)
    local l = (max + min) / 2

    -- Check if there is saturation
    local s
    if min == max then
        -- If min and max are equal, there is no saturation
        s = 0
    else
        if l <= 0.5 then
            s = (max - min) / (max + min)
        else
            s = (max - min) / (2 - max - min)
        end
    end

    -- Calculate hue (H)
    local h
    if max == min then
        -- If max and min are equal, it's a shade of gray (H is undefined)
        h = 0
    else
        if max == r then
            h = (g - b) / (max - min)
        elseif max == g then
            h = 2 + (b - r) / (max - min)
        else
            h = 4 + (r - g) / (max - min)
        end
        h = h / 6 -- Convert to range 0-1
        if h < 0 then
            h = h + 1
        end -- Add 1 if negative
    end

    -- Convert hue to degrees
    h = h * 360

    return M.round(h), M.round(s * 100), M.round(l * 100)
end

--- @param h number
--- @param s number
--- @param l number
--- @return number red
--- @return number green
--- @return number blue
function M.hsl_to_rgb(h, s, l)
    h = h / 360
    s = s / 100
    l = l / 100

    local function hueToRgb(p, q, t)
        if t < 0 then
            t = t + 1
        end
        if t > 1 then
            t = t - 1
        end
        if t < 1 / 6 then
            return p + (q - p) * 6 * t
        end
        if t < 1 / 2 then
            return q
        end
        if t < 2 / 3 then
            return p + (q - p) * (2 / 3 - t) * 6
        end
        return p
    end

    if s == 0 then
        local gray = M.round(l * 255)
        return gray, gray, gray
    else
        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q

        local red = M.round(hueToRgb(p, q, h + 1 / 3) * 255)
        local green = M.round(hueToRgb(p, q, h) * 255)
        local blue = M.round(hueToRgb(p, q, h - 1 / 3) * 255)

        return red, green, blue
    end
end

--- @param color string
--- @param factor float
--- @return string color
function M.darken(color, factor)
    local r, g, b = M.hex_to_rgb(color)
    local h, s, l = M.rgb_to_hsl(r, g, b)

    l = l * (1 - factor)

    local new_r, new_g, new_b = M.hsl_to_rgb(h, s, l)
    return M.rgb_to_hex(new_r, new_g, new_b)
end

--- @param color string
--- @param factor float
--- @return string color
function M.lighten(color, factor)
    local r, g, b = M.hex_to_rgb(color)
    local h, s, l = M.rgb_to_hsl(r, g, b)

    l = l + (100 - l) * factor

    local new_r, new_g, new_b = M.hsl_to_rgb(h, s, l)
    return M.rgb_to_hex(new_r, new_g, new_b)
end

--- @param hex_fg string
--- @param hex_bg string
--- @param alpha float
--- @return string color
function M.blend(hex_fg, hex_bg, alpha)
    local red_bg, green_bg, blue_bg = M.hex_to_rgb(hex_bg)
    local red_fg, green_fg, blue_fg = M.hex_to_rgb(hex_fg)

    local min = math.min
    local max = math.max
    local floor = math.floor

    local function blend_channel(fg, bg)
        local blended_channel = alpha * fg + ((1 - alpha) * bg)

        return floor(min(max(0, blended_channel), 255) + 0.5)
    end

    return M.rgb_to_hex(blend_channel(red_fg, red_bg), blend_channel(green_fg, green_bg), blend_channel(blue_fg, blue_bg))
end

function M.blend_hue(hex_a, hex_b, alpha)
    local r1, g1, b1 = M.hex_to_rgb(hex_a)
    local r2, g2, b2 = M.hex_to_rgb(hex_b)

    local h1, s1, l1 = M.rgb_to_hsl(r1, g1, b1)
    local h2, s2, l2 = M.rgb_to_hsl(r2, g2, b2)

    local h = h1 * alpha + h2 * (1 - alpha)
    return M.rgb_to_hex(M.hsl_to_rgb(h, s1, l1))
end




return M
