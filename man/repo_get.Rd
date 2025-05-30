% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/repo-set.R
\name{repo_get}
\alias{repo_get}
\alias{repo_resolve}
\alias{repo_add}
\alias{with_repo}
\title{Query and set the list of CRAN-like repositories}
\usage{
repo_get(
  r_version = getRversion(),
  bioc = TRUE,
  cran_mirror = default_cran_mirror()
)

repo_resolve(spec, username = NULL)

repo_add(..., .list = NULL, username = NULL)

with_repo(repos, expr)
}
\arguments{
\item{r_version}{R version(s) to use for the Bioconductor repositories,
if \code{bioc} is \code{TRUE}.}

\item{bioc}{Whether to add Bioconductor repositories, even if they
are not configured in the \code{repos} option.}

\item{cran_mirror}{The CRAN mirror to use, see
\code{\link[=default_cran_mirror]{default_cran_mirror()}}.}

\item{spec}{A single repository specification, a possibly named
character scalar. See details below.}

\item{username}{User name to set, for authenticated repositories, see
\code{\link[=repo_auth]{repo_auth()}}.}

\item{...}{Repository specifications. See details below.}

\item{.list}{List or character vector of repository specifications,
see details below.}

\item{repos}{A list or character vector of repository specifications.}

\item{expr}{R expression to evaluate.}
}
\value{
\code{repo_get()} returns a data frame with columns:
\itemize{
\item \code{name}: repository name. Names are informational only.
\item \code{url}: repository URL.
\item \code{type}: repository type. This is also informational, currently it
can be \code{cran} for CRAN, \code{bioc} for a Bioconductor repository, and
\code{cranlike}: for other repositories.
\item \code{r_version}: R version that is supposed to be used with this
repository. This is only set for Bioconductor repositories. It is \code{*}
for others. This is also informational, and not used when retrieving
the package metadata.
\item \code{bioc_version}: Bioconductor version. Only set for Bioconductor
repositories, and it is \code{NA} for others.
\item \code{username}: user name, for authenticated repositories.
\item \code{has_password}: whether \code{repo_get()} could find the password for
this repository. Call \code{\link[=repo_auth]{repo_auth()}} for more information if the
credential lookup failed.
}

\code{repo_resolve()} returns a named character vector, with the URL(s) of
the repository.

\code{repo_add()} returns the same data frame as \code{repo_get()}, invisibly.

\code{with_repo()} returns the value of \code{expr}.
}
\description{
pkgcache uses the \code{repos} option, see \code{\link[=options]{options()}}. It also automatically
uses the current Bioconductor repositories, see \code{\link[=bioc_version]{bioc_version()}}.
These functions help to query and manipulate the \code{repos} option.
}
\details{
\code{repo_get()} queries the repositories pkgcache uses. It uses the
\code{repos} option (see \link{options}), and also the default Bioconductor
repository.

\code{repo_resolve()} resolves a single repository specification to a
repository URL.

\code{repo_add()} adds a new repository to the \code{repos} option. (To remove
a repository, call \code{option()} directly, with the subset that you want
to keep.)

\code{with_repo()} temporarily adds the repositories in \code{repos},
evaluates \code{expr}, and then resets the configured repositories.
}
\section{Repository specifications}{
The format of a repository specification is a named or unnamed
character scalar. If the name is missing, pkgcache adds a name
automatically. The repository named \code{CRAN} is the main CRAN repository,
but otherwise names are informational.

Currently supported repository specifications:
\itemize{
\item URL pointing to the root of the CRAN-like repository. Example:

\if{html}{\out{<div class="sourceCode">}}\preformatted{https://cloud.r-project.org
}\if{html}{\out{</div>}}
\item \code{PPM@latest}, PPM (Posit Package Manager, formerly RStudio Package
Manager), the latest snapshot.
\item \verb{PPM@<date>}, PPM (Posit Package Manager, formerly RStudio Package
Manager) snapshot, at the specified date.
\item \verb{PPM@<package>-<version>} PPM snapshot, for the day after the
release of \verb{<version>} of \verb{<package>}.
\item \verb{PPM@R-<version>} PPM snapshot, for the day after R \verb{<version>}
was released.
}

Still works for dates starting from 2017-10-10, but now deprecated,
because MRAN is discontinued:
\itemize{
\item \verb{MRAN@<date>}, MRAN (Microsoft R Application Network) snapshot, at
the specified date.
\item \verb{MRAN@<package>-<version>} MRAN snapshot, for the
day after the release of \verb{<version>} of \verb{<package>}.
\item \verb{MRAN@R-<version>} MRAN snapshot, for the day
after R \verb{<version>} was released.
}

Notes:
\itemize{
\item See more about PPM at \url{https://packagemanager.posit.co/client/#/}.
\item The \verb{RSPM@} prefix is still supported and treated the same way as
\verb{PPM@}.
\item The MRAN service is now retired, see
\verb{https://techcommunity.microsoft.com/blog/azuresqlblog/microsoft-r-application-network-retirement/3707161}
for details.
\item \code{MRAN@...} repository specifications now resolve to PPM, but note that
PPM snapshots are only available from 2017-10-10. See more about this
at \url{https://posit.co/blog/migrating-from-mran-to-posit-package-manager/}.
\item All dates (or times) can be specified in the ISO 8601 format.
\item If PPM does not have a snapshot available for a date, the next
available date is used.
\item Dates that are before the first, or after the last PPM snapshot
will trigger an error.
\item Unknown R or package versions will trigger an error.
}
}

\examples{
repo_get()
\dontshow{if (pkgcache:::run_examples()) withAutoprint(\{ # examplesIf}
repo_resolve("PPM@2021-01-21")
#' repo_resolve("PPM@dplyr-1.0.0")
#' repo_resolve("PPM@R-4.0.0")
\dontshow{\}) # examplesIf}
\dontshow{if (pkgcache:::run_examples()) withAutoprint(\{ # examplesIf}
with_repo(c(CRAN = "PPM@dplyr-1.0.0"), repo_get())
with_repo(c(CRAN = "PPM@dplyr-1.0.0"), meta_cache_list(package = "dplyr"))

with_repo(c(CRAN = "MRAN@2018-06-30"), summary(repo_status()))
\dontshow{\}) # examplesIf}
}
\seealso{
Other repository functions: 
\code{\link{repo_status}()}
}
\concept{repository functions}
