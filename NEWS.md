# EIAdata 0.2.0

- Updated `EIAdata` for version 2 of the EIA API.
- Removed the `getCatEIA` function because it is no longer supported by the EIA API.
- `EIAdata` only supports referencing series by `seriesid`.
- If you don't know the Series IDs for the data you want, do the following:

1.  Go to [EIA's Opendata website](https://www.eia.gov/opendata/).
2.  Go to the "Bulk File Downloads" by scrolling down a bit and looking on the right margin.
3.  Choose the bulk download for the category that contains the series you want.  Foe example if it is a Crude Oil series download the "Petroleum" file.
4.  After the file downloads unzip it and find the Series ID you want. 

# EIAdata 0.1.3

- Updated `getEIA` and `getCatEIA` to use https.  This required adding the `httr` package as an additional dependency.

# EIAdata 0.1.2

- Removed `wngsr` because it was causing trouble in the CRAN checks.  It was also not widely used as far as I know. The function is still available in the `continue_with_wngsr` branch.
