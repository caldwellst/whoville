# whoville 0.1.6

* Minor change to accommodate new formatting for the World Bank's historical classification by income for countries.

# whoville 0.1.5

* Added UN intermediate regions, UN DESA regions and subregions, and SDG regions
and subregions.

# whoville 0.1.4

* Small island developing states (SIDS) and land-locked developing countries (LLDC)
    classifications added to `countries`.
* Additional alt names from official ISO3 short names added.

# whoville 0.1.3

* UN region and subregion names added in for every language, which can be accessed
    using `iso3_to_regions()`.
* OECD membership added, usable through `is_oecd_member()` and `oecd_member_states().
* GBD 2019 high-income countries added, usable through `is_gbd_high_income()` and
    `gbd_high_income_states()`.
* UN least-developed country status added, usable through `is_un_ldc()` and 
    `un_ldcs()`.

# whotilities 0.1.2

* Country data updated to use WHO xMart4 REF_MART data. This has created changes across all functions and in the package.
* WHO formal and short names now available in all languages
* Reduced the number of country codes available to ISO3, ISO2, ISO (numeric), WHO code, and M49
* Increased numbers of countries to 248
* Accessed World Bank Income Group data directly from World Bank website, now have income group classifications for 1987 - 2019 (corresponds to fiscal year 1989 - 2021)

# whotilities 0.1.1

* Added a `NEWS.md` file to track changes to the package.
* Added `who_member_states()` to quickly extract ISO3 codes for all WHO member states

# whotilities 0.1.0

* Initial release of package
* Publication of `countries` dataframe with codes, names, and regional categorizations
* Added functions to coerce names to codes (and vice-versa) released
* Added functions to get key country information using ISO3 codes
