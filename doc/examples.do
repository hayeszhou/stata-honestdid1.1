* Example 1: Benzarti and Carloni (2019)
* --------------------------------------

* Construct robust confidence intervals for DeltaRM(Mbar) for first
* post-treatment period.

tempname beta sigma
mata {
    st_matrix(st_local("beta"),  _honestExampleBCBeta())
    st_matrix(st_local("sigma"), _honestExampleBCSigma())
}
local opts mvec(0(0.5)2) gridPoints(100) grid_lb(-1) grid_ub(1)
honestdid, reference(4) b(`beta') vcov(`sigma') `opts'

* The results are printed to the Stata console and saved in a mata object. The user
* can specify the name of the mata object via the {opt mata()} option. The default
* name is HonestEventStudy and the object's name is saved in {cmd:s(HonestEventStudy)}.
* In addition to the CI, all the inputs and options are saved:

mata `s(HonestEventStudy)'.CI
mata `s(HonestEventStudy)'.betahat
mata `s(HonestEventStudy)'.sigma
mata `s(HonestEventStudy)'.referencePeriod
mata `s(HonestEventStudy)'.prePeriodIndices
mata `s(HonestEventStudy)'.postPeriodIndices

mata `s(HonestEventStudy)'.options.alpha
mata `s(HonestEventStudy)'.options.l_vec
mata `s(HonestEventStudy)'.options.Mvec
mata `s(HonestEventStudy)'.options.rm
mata `s(HonestEventStudy)'.options.method
mata `s(HonestEventStudy)'.options.Delta
mata `s(HonestEventStudy)'.options.grid_lb
mata `s(HonestEventStudy)'.options.grid_ub
mata `s(HonestEventStudy)'.options.gridPoints

* For ease of use, the package also provides a way to plot the CIs
* using the {cmd:coefplot} package. This can be done when the CIs
* are computed or using the results cached in mata.

honestdid, coefplot cached
honestdid, coefplot cached xtitle(Mbar) ytitle(95% Robust CI)
graph export coefplot.pdf, replace

* Example 2: Lovenheim and Willen (2019)
* --------------------------------------

use test/LWdata_RawData.dta, clear
mata stata(_honestExampleLWCall())
honestdid, pre(1/9) post(10/32) coefplot

* This required the user package {cmd:reghdfe}. First, you can see
* that we did not need to specify the coefficient vector or the
* variance-covariance vector, and instead the function took the stored
* results {cmd e(b)} and {cmd e(V)} from {cmd:reghdfe} to do the
* computations. Further, the coefficient plot was created using the
* {cmd:coefplot} package.

* Now to mirror the Vignette:
matrix b = 100 * e(b)
matrix V = 100^2 * e(V)
mata st_matrix("l_vec", _honestBasis(15 - (-2), 23))
local opts norelmag mvec(0(0.005)0.04) l_vec(l_vec)
local plot coefplot xtitle(Mbar) ytitle(95% Robust CI)
honestdid, pre(1/9) post(10/32) b(b) vcov(V) `opts' `plot'
graph export coefplot.pdf, replace