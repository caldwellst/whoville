#' Get country codes from names.
#'
#' `names_to_code()` takes in a vector of country names and returns a vector of
#' specified country codes.
#'
#' The function first searches for exact matches in the `countries`
#' data frame, and if none are found, uses fuzzy matching to guess the country.
#' Matching is done using `stringdist` [fuzzy matching methods][stringdist::stringdist-metrics],
#' although `names_to_code()` allows the user to not do any fuzzy matching (non-exact
#' matches returned as `NA`) or require user input.
#'
#' @param names A character vector of country names.
#' @param code A character value specifying the type of country code to return.
#'     Defaults to ISO3. All possible values available through `country_code_types()`.
#' @param language A character value specifying the language of the country names.
#'     Should be specified using the ISO2 language code. Defaults to "en", but matching
#'     available for all 6 official WHO languages. Possible values are "en", "es",
#'     "ar", "fr", "ru", and "zh".
#' @param ignore_case A logical value specifying whether or not to ignore case when
#'     string matching. Defaults to TRUE.
#' @param fuzzy_matching A character value specifying whether or not to do fuzzy matching,
#'     or to require user input when no exact match is found. Defaults to "yes".
#' @param method A character value specifying the distance method for use in fuzzy matching
#'     if an exact match is not found. Defaults to Jaro-Winker due to its value
#'     in matching names. See [stringdist::stringdist()] for all possible methods.
#' @param p A numeric value between 0 and 0.25 specifying the penalty factor
#'     for Jaro-Winkler distance. Ignored if method is not "jw".
#'
#' @return A vector of country codes matched to the names.
#'
#' @export
names_to_code <- function(names,
                          code = "iso3",
                          language = "en",
                          ignore_case = T,
                          fuzzy_matching = "yes",
                          method = "jw",
                          p = 0.1) {
  rlang::arg_match(code, country_code_types())
  rlang::arg_match(language, c("en", "es", "ru", "ar", "zh", "fr"))
  assert_logical(ignore_case)
  assert_fuzzy_matching(fuzzy_matching)
  rlang::arg_match(method, c("osa", "lv", "dl", "hamming", "lcs", "qgram", "cosine", "jaccard", "jw", "soundex"))
  assert_p(p)

  data("countries", envir = environment())

  df <- dplyr::select(countries[,name_cols()],
                      dplyr::ends_with(language))
  if (ignore_case) {
    df <- dplyr::mutate(df,
                        dplyr::across(dplyr::everything(),
                                      tolower))
    names <- tolower(names)
  }
  result <- sapply(names,
                   name_matching,
                   df = df,
                   method = method,
                   p = p,
                   fm = fuzzy_matching,
                   code = code,
                   countries = countries)
  unname(result)
}

#' @noRd
name_matching <- function(name,
                          df,
                          method,
                          p,
                          fm,
                          code,
                          countries) {
  scrs <- apply(df, 2, stringdist::stringdist, name, method = method, p = p)
  scr_mins <- apply(scrs, 1, function(x) suppressWarnings(min(x, na.rm = T)))
  row <- which.min(scr_mins)
  col <- apply(scrs, 1, which.min)[[row]]
  fit <- df[row, col]
  fuzz_result <- countries[[code]][row]
  if (min(scr_mins) != 0) {
    if (fm == "no") {
      result <- NA_character_
    } else {
      if (fm == "yes") {
        message("'", name, "' has no exact match. Closest name found was '", fit, "'.")
        result <- fuzz_result
      } else {
        check <- T
        while (check) {
          message("The best match found for '", name, "' is '", fit, "' with ", toupper(code)," code ", fuzz_result, ".")
          result <- readline(sprintf("Confirm the correct %s code for %s. Type 'N/A' to skip this country: ",
                                     toupper(code),
                                     name))
          if (result %in% c("N/A", countries[[code]])) {
            check <- F
            if (result == "N/A") result <- NA_character_
          } else {
            check_input <- readline(sprintf("%s is not a valid %s code found in the countries file. Please confirm if %s is correct (y/n): ",
                                            result,
                                            toupper(code),
                                            result))
            if (tolower(check_input) == "y") {
              check <- F
            } else {
              message("Since not 'y', repeating entry for ", name, ".")
            }
          }
        }
      }
    }
  } else {
    result <- fuzz_result
  }
  result
}

#' @noRd
assert_p <- function(p) {
  lngth <- length(p)
  if (lngth > 1) {
    stop(sprintf("p must be of length 1, not %s",
                 lngth),
         call. = FALSE)
  }

  cls <- class(p)
  if (!is.numeric(p)) {
    stop(sprintf("p must be a numeric value, not %s",
                 cls),
         call. = FALSE)
  }

  if (!dplyr::between(p, 0, 0.25)) {
    stop(sprintf("p must be between 0 and 0.25, not %s",
                 p),
         call. = FALSE)
  }
}

assert_fuzzy_matching <- function(fuzzy_matching) {
  rlang::arg_match(fuzzy_matching, c("yes", "no", "user_input"))
  if (fuzzy_matching == "user_input" & !interactive()) {
    stop("R session must be interactive if fuzzying_matching is seting to 'user_input'. See ?interactive for more details.")
  }
}