# EIAdata 0.1.3

- Updated `getEIA` and `getCatEIA` to use https.  This required adding the `httr` package as an additional dependency.

# EIAdata 0.1.2

- Removed `wngsr` because it was causing trouble in the CRAN checks.  It was also not widely used as far as I know. The function is still available in the `continue_with_wngsr` branch.
