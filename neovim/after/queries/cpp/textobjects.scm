; extends

(case_statement
  .
  _
  ":"
  _+ @case.inner) @case.outer

(case_statement) @case.outer
