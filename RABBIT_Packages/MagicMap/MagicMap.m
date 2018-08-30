(* Mathematica Package *)

(* Created by the Wolfram Workbench Jun 24, 2016 *)

(* Mathematica Package *)

BeginPackage["MagicMap`",{"SpectralOrdering`","Optimization1D`","ContinuousTimeHmm`",
    "MagicDefinition`","MagicDataFilter`",
    "MagicOrigin`","MagicOriginXY`","PedigreeOrigin`","MagicGeneDropping`",
    "MagicDataPreprocess`","MagicReconstruct`","MagicImpute`",
    "MagicReconstruct`MagicModel`","MagicReconstruct`MagicLikelihood`"}]

(* Exported symbols added here with SymbolName::usage *)  

magicMap::usage = "magicMap[magicsnp, model, popdesign,ngroup]performs linage map construction in multi-parental populations. The magicsnp specifies the input genotypic data matrix or filename. The model specifies whether the maternally and paternally derived chromosomes are indepdent (\"indepModel\"), completely dependent (\"depModel\"), or  modeled jointly (\"jointModel\"). The popdesign specifies the breeding design information in several possible ways: a list of mating schemes from founder population to the last generation, a list of values denoting the junction distribution, or a filename for population  pedigree information. The ngroup specifies the number of linkage groups. "

magicPairwiseSimilarity::usage = "magicPairwiseSimilarity[magicsnp, model, popdesign] performs two-locus linkage and independence analyses for all pairs of markers. The magicsnp specifies the input genotypic data matrix or filename. The model specifies whether the maternally and paternally derived chromosomes are indepdent (\"indepModel\"), completely dependent (\"depModel\"), or  modeled jointly (\"jointModel\"). The popdesign specifies the breeding design information in several possible ways: a list of mating schemes from founder population to the last generation, or a filename for population  pedigree information. "

magicMapConstruct::usage = "magicMapConstruct[[pairwisedatafile, ngroup] constructs an initial genetic linakage map by spectral clustering and ordering, with inter-marker distances being based on two-linkage analyses. The pairwisedatafile is the output file returned by magicPairwiseSimilarity. The ngroup specifies the number of linkage groups. "

magicMapRefine::usage = "magicMapRefine[initialmap, magicsnp, model, popdesign] performs iterative improvement of the initialmap returned by magicMapConstruct. The magicsnp specifies the input genotypic data matrix or filename. The model specifies whether the maternally and paternally derived chromosomes are indepdent (\"indepModel\"), completely dependent (\"depModel\"), or  modeled jointly (\"jointModel\"). The popdesign specifies the breeding design information in several possible ways: a list of mating schemes from founder population to the last generation, or a filename for population  pedigree information. "  

magicGrouping::usage = "magicGrouping[similarity, ngroup] performs grouping from the similarity matrix, with a pre-specified number ngroup of gorups. "
 
magicLinkage::usage = "magicLinkage[magicsnp, model, popdesign] performs only multi-locus marker spacing. The initial genetic map is contained in magicsnp. "

correctingThreshold::usage = "correctingThreshold is an option to specify a correction threshold. An observed genotype is corrected only if the posterior probability of the true genotype is greater than the threshold and is greater than the posterior probability of the observed genotype."

nReplicateAnnealing::usage = "nReplicateAnnealing is an option to specify the number of times repeating simulated annealing. "

initTemperature::usage = "initTemperature is an option to specify the initial annealing temperature. "

coolingRate::usage = "coolingRate is an option to specify the cooling rate of annealing temperature. "

freezingTemperature::usage = "freezingTemperature is an option specify the freezing temperature at which cooling rate increases. "

deltLoglThreshold::usage = "deltLoglThreshold is an option to specify the stopping threshold. Simulated annealing is finished if the change of log likelihood is small than the threshold in three consecutive iterations. "

referenceMap::usage = "referenceMap is an option to specify the filename of a reference map, which is used only to compare with estimated map.  "

minLodSaving::usage = "minLodSaving is an option to specify the minimum LOD score for saving results. For a given pair of markers, If the LOD of linkage analysis or independence test is smaller than the threshold, the two-locus analysis will not be saved. "

minLodClustering::usage = "minLodClustering is an option to specify the minimum LOD score for clustering. The similarity between two markers is set to 0 if its LOD socre is smaller than the LOD threshold. "

minLodOrdering::usage = "minLodOrdering is an option to specify the minimum LOD score for ordering. The similarity between two markers is set to 0 if its LOD socre is smaller than the LOD threshold. . "

nNeighborSaving::usage = "nNeighborSaving is an option to specify the number of strongest neighbors to be saved for magicMapRefine. "

miniComponentSize::usage = "miniComponentSize is an option to specify the minimum size of a graph component. The markers in a component is ungrouped if the component size is smaller than the threshold. "

computingLodType::usage = "computingLodType is an option to specify the type of two-locus analysis. It must be one of \"independence\", \"linkage\", and \"both\", corresponding to independence test, linkage analysis, or both. "

lodTypeClustering::usage = "lodTypeClustering is an option to specify the LOD type for clustering. It must be one of \"independence\", \"linkage\", and \"both\", corresponding to independence test, linkage analysis, or both. "

lodTypeOrdering::usage = "lodTypeOrdering is an option to specify the LOD type for ordering. It must be one of \"independence\", \"linkage\", and \"both\", corresponding to independence test, linkage analysis, or both. "

nNeighborFunction::usage = "nNeighborFunction is an option to specify the pure function defined the number of neighbors used in spectral ordering in magicMapConstruct. "

rescaleSimilarity::usage = "rescaleSimilarity is an option of plotHeatMap to specify whether to rescale recombination fraction or LOD score. "

readPairwiseDatafile::usage = "readPairwiseDatafile[pairwisedatafile] extracts the all components from the pairwisedatafile returned by magicPairwiseSimilarity. It returns {lodtype,isfounderinbred,minlodsaving, morganrate, snpid, rfmtx, linklodmtx, indeplodmtx}. "

plotMapComparison::usage = "plotMapComparison[estmap, refmap, isordering,linestyle] plot estimated map estmap vs reference map refmap. Comparsons are in terms of marker ordering (isordering = True) or marker position (isordering = False). The style of chromosome boundary lines is specified by linestyle. "

plotHeatMap::usage = "plotHeatMap[pairwisedatafile, mapfile] returns heat map of pairwise recombination fraction or LOD score matrix. The pairwisedatafile is the outputfile resturned by magicPairwiseSimilarity, and the mapfile provides information on marker id, marker grouping and ordering. "

plotHeatMapGUI::usage = "plotHeatMapGUI[pairwisedatafile, mapfile] returns a graph user interface for manipulating heat map of pairwise recombination fraction or LOD score matrix. The pairwisedatafile is the outputfile resturned by magicPairwiseSimilarity, and the mapfile provides information on marker id, marker grouping and ordering. "

nConnectedComponent::usage = "nConnectedComponent is an option to specify the number of connected components except of mini-components"

getSimilarity::usage = "getSimilarity  "

findminlodBrent::usage = "findminlodBrent  "

toSparseIndicator::usage = "toSparseIndicator  "

fractiontosimilarity::usage = "fractiontosimilarity  "

getNeighborLodMtx::usage = "getNeighborLodMtx  "

decomposeRoughMap::usage = "decomposeRoughMap  "

isImputingFounder::usage = "isImputingFounder is an option"

delStrongCrossLink::usage = "delStrongCrossLink is an option"

dropMinicluster::usage = "dropMinicluster  "

adjConnectedComponents::usage = "adjConnectedComponents  "

mapPreprocessing::usage = "mapPreprocessing  "

findFractionMLE::usage = "findFractionMLE  "

calloglfunc::usage = "calloglfunc  "

basiclogl::usage = "basiclogl  "

calbasiclogl::usage = "calbasiclogl  "

basicloglconst::usage = "basicloglconst  "

Begin["`Private`"] (* Begin Private Context *) 

(*gethaplotran[n_, r_] :=
    (1 - n r/(n - 1)) IdentityMatrix[n] + r/(n - 1)
    
gethaplotran[nFgl_, lab_, r_] :=
    Module[ {res},
        res = ConstantArray[0, {nFgl, nFgl}];
        res[[lab, lab]] = gethaplotran[Length[lab], r];
        res
    ]*)
    
gethaplotran[initial_, r_] :=
    Module[ {res, i},
        res = Table[initial r, {Length[initial]}];
        Do[
          If[ initial[[i]] == 0,
              res[[i]] = Table[0, {Length[initial]}],
              res[[i, i]] = 0;
              res[[i, i]] = 1 - Total[res[[i]]]
          ], {i, Length[res]}];
        res
    ]    

(*return list of indlist\[Rule]tranlist;tranlist =list of \
{{a,b,c},indexlist} so that the transition probability terms at the \
indexlist are given by a+br+cr^2*)
getPairPriorProb[model_, samplelabel_, samplemarkovprocess_, ismaleX_] :=
    Module[ {process = samplemarkovprocess, originitial, morganrate,
      joinprior, temp, r, res, haplocode, diplocode, code, rule, tran, 
      order,i,j,ind,nstate,priortrancode,priortranset,nFgl,diplotype,pos},
        Switch[model,
           "depModel",
          originitial = Normal[process[[All, 2, 1]]]/. {0. -> 0};
          joinprior = (# gethaplotran[#, r] & /@ originitial) /. {0. -> 0};
          order = 1;
          nstate = Length[First[originitial]],
          "indepModel",
          originitial = Normal[process[[All, 2, 1]]] /. {0. -> 0};
          joinprior = Table[
             nFgl = Sqrt[Length[originitial[[i]]]];
             diplotype = origGenotype[nFgl][[1, 2]];
             rule = Thread[diplotype -> Range[nFgl^2]];
             temp = Select[Transpose[{originitial[[i]], diplotype}], (#[[1]] > 0 &)];
             temp = Table[{#[[1, 1]], Total[#[[All, 2]]]} & /@ GatherBy[Transpose[{temp[[All, 2, j]], temp[[All, 1]]}],First], {j, 2}];
             temp = Transpose[SortBy[#, First]] & /@ temp;
             joinprior = SparseArray[{}, {nFgl^2, nFgl^2}];
             pos = Flatten[Outer[List, Sequence @@ temp[[All, 1]]], 1] /. rule;
             joinprior[[pos, pos]] = KroneckerProduct @@ (# gethaplotran[#, r] & /@ temp[[All, 2]]);
             Normal[joinprior], {i, Length[originitial]}];
          order = 2;
          nstate = Length[First[joinprior]];
        ];
        process[[All, 2]] = Table[
          temp = DeleteCases[Union[Flatten[joinprior[[i]]]], 0];
          {PadRight[CoefficientList[#, r], order+1], Position[joinprior[[i]], #, {2}, Heads -> True]} & /@ temp, {i,Length[joinprior]}];
        res = Table[
          {haplocode, diplocode} = samplelabel[[ind + 1, 4 ;; 5]];
          tran = samplelabel[[ind + 1, 2]] /. process;
          If[ ! OrderedQ[haplocode],
              code = If[ ismaleX[[ind]]||model==="depModel",
                         haplocode,
                         diplocode
                     ];
              rule = Thread[Range[Length[code]] -> code];
              tran[[All, 2]] = Replace[tran[[All, 2]], rule, {2}];
          ];
          tran[[All, 2]] = Sort[#] & /@ ((tran[[All, 2, All, 1]] - 1) nstate + tran[[All, 2, All, 2]]);
          {ind, tran}, {ind, Length[samplelabel] - 1}];
        res = SortBy[res, Last];
        res = #[[All, 1]] -> #[[1, 2]] & /@ SplitBy[res, Last];
        If[ Union[Flatten[res[[All, 1]]]] =!= Range[Length[ismaleX]],
            Print["getdiploTran: wrong individuals!"];
            Abort[]
        ];
        priortrancode = Flatten[MapIndexed[Thread[#1 -> First[#2]] &, res[[All, 1]]]];
        priortrancode = Range[Length[priortrancode]] /. priortrancode;
        priortranset = res[[All, 2]];
        morganrate = Table[Mean[Abs[Select[Eigenvalues[samplemarkovprocess[[i, 2, 2]]], Negative]]], {i,Length[samplemarkovprocess]}];
        morganrate = Mean[priortrancode /. Thread[Range[Length[morganrate]] -> morganrate]];
        {morganrate,priortrancode,priortranset}
    ]
               
calmaxfraction[continuedmarkovprocess_,isdepModel_] :=
    Module[ {temp, nfgl, geno, n},
        If[ isdepModel,
            (*n = Total[#] & /@ Boole[Positive[continuedmarkovprocess[[All, 2, 1]]]];
            N[Mean[(n - 1)/n]],*)
            temp = Normal[continuedmarkovprocess[[All, 2, 1]]];
            Mean[#.(1 - #) & /@ temp],
            temp = Sign[Normal[continuedmarkovprocess[[All, 2, 1]]]];
            nfgl = Sqrt[Last[Dimensions[temp]]];
            geno = origGenotype[nfgl][[1, 2]];
            temp = Pick[geno, #, 1] & /@ temp;
            n = Mean[Flatten[Map[Length[Union[#]] &, Transpose[#] & /@ temp, {2}]]];
            (n - 1.)/n
        ]
    ]
                                                 
mapPreprocessing[inputmagicSNP_, model_, popDesign_, epsF_, minphredscore_, maxfoundererror_, foundergenocallbound_, 
  isfounderinbred_, inputisfounderdepth_, inputisoffspringdepth_,isprint_] :=
    Module[ {ischrX = False,magicSNP = inputmagicSNP, isfounderdepth = inputisfounderdepth, isoffspringdepth = inputisoffspringdepth, 
        snpid,deltd, founderHaplo,obsGeno, snpMap, haploMap, nFounder, posA, posX, foundergender, offspringgender, 
        founderid, sampleid, samplelabel, rules, priortrancode,priortranset,continuedMarkovProcess, morganrate, ismaleX, isfoundermaleX,malepos, ch, 
      continuedmarkovprocess, founderhaplo, obsgeno, fhaploset,founderhaplorule},
         (*only one group, autosome or sex chromosome*)
         (*set arbitray increasing SNP locations to avoid wrong checking of  genetic map*)
        (*setting linkage group as missing values*)
        magicSNP[[3, 2 ;;]] = If[ ischrX,
                                  "x",
                                  1
                              ];
        magicSNP[[4, 2 ;;]] = Range[Length[magicSNP[[4, 2 ;;]]]];
        SNPValidation[magicSNP, isfounderinbred, isfounderdepth, isoffspringdepth];
        (*founderHapo dimensions {nfounder,nchr,nsnp}*)
        (*obsGeno dimensions {noffspring,nchr,nsnp}*)
        {deltd, founderHaplo, obsGeno, snpMap, haploMap, nFounder, posA, 
          posX, foundergender, offspringgender, founderid, sampleid} = 
         transformMagicSNP[magicSNP, isfounderinbred, isfounderdepth, isoffspringdepth];
        snpid = snpMap[[1,2;;]];
        {samplelabel, continuedMarkovProcess} = sampleContinuedPriorProcess[nFounder, popDesign, isfounderinbred, model, posA, posX, offspringgender, sampleid];
        ismaleX = ConstantArray[False, {Length[offspringgender], Length[posA] + Length[posX]}];
        malepos = Position[offspringgender, "Male"];
        ismaleX[[malepos, posX]] = True;
        (*only one group autosome or sex chromosome*)
        ch = 1;
        ismaleX = ismaleX[[All, ch]];
        continuedmarkovprocess = continuedMarkovProcess;
        continuedmarkovprocess[[All, 2]] = continuedMarkovProcess[[All, 2, All, ch]];
        {morganrate,priortrancode,priortranset} = getPairPriorProb[model, samplelabel, continuedmarkovprocess, ismaleX];        
        (*Put[morganrate,priortrancode,priortranset,model, samplelabel, continuedmarkovprocess, ismaleX,"temp.txt"];
        Abort[];*)
        founderhaplo = Transpose[founderHaplo[[All, ch]]];
        obsgeno = Transpose[obsGeno[[All, ch]]];
        If[ ! MemberQ[posX, ch],
            isfoundermaleX = Table[False, {Length[foundergender]}],
            isfoundermaleX = MatchQ[#, "Male" | "male"] & /@ foundergender
        ];
        If[ isfounderdepth,
            fhaploset = Map[siteParentHaploPriorGBS[#, epsF, minphredscore,maxfoundererror, foundergenocallbound, isfoundermaleX,isfounderinbred] &,founderhaplo],
            fhaploset = Map[siteParentHaploPrior[#, epsF, isfoundermaleX,isfounderinbred, maxfoundererror] &, founderhaplo];
        ];
        founderhaplorule = Union[Flatten[fhaploset[[All, All, 1]], 1]];
        rules = Thread[founderhaplorule -> Range[Length[founderhaplorule]]];
        fhaploset[[All, All, 1]] = Replace[fhaploset[[All, All, 1]], rules, {2}];
        founderhaplorule = Reverse[#] & /@ rules;
        {morganrate,snpid,fhaploset, founderhaplorule,obsgeno, priortrancode,priortranset,ismaleX}
    ]
    
calbasicdataprob[fhaplo_, geno_, model_, epsF_, eps_, minphredscore_, ismalex_, isoffspringdepth_] :=
    Module[ {prob, nFgl, ii},
        prob = If[ isoffspringdepth,
                   siteMagicLikelihoodGBS[model,{fhaplo}, {geno}, epsF, eps, minphredscore, {ismalex}],
                   siteMagicLikelihood[model,{fhaplo}, {geno}, epsF, eps, {ismalex}]
               ];
        prob = prob[[1, 1]];
        nFgl = Length[fhaplo];
        If[ ismalex&&(ToLowerCase[model] =!= "depModel"),
            ii = (Range[nFgl] - 1) nFgl + Range[nFgl];
            prob = prob[[ii]]
        ];
        prob
    ]

calbasiclogl[fhaplocode1_, fhaplocode2_, geno1_, geno2_, ismalex_,indpriorcode_,basicloglconst_] :=
    Module[ {priortranset,model, epsF, eps, minphredscore, isoffspringdepth,founderhaplorule, 
        fhaplo1, fhaplo2, prob1, prob2, prob12},
        {priortranset, founderhaplorule, model, epsF, eps, minphredscore, isoffspringdepth} = basicloglconst;        
        {fhaplo1, fhaplo2} = {fhaplocode1, fhaplocode2}/.founderhaplorule;
        prob1 = calbasicdataprob[fhaplo1, geno1, model, epsF, eps, minphredscore,ismalex, isoffspringdepth];
        prob2 = calbasicdataprob[fhaplo2, geno2, model, epsF, eps, minphredscore, ismalex, isoffspringdepth];
        prob12 = Flatten[KroneckerProduct[prob1, prob2]];
        Total[#[[1]] Total[prob12[[#[[2]]]]] & /@ priortranset[[indpriorcode]]]
    ]    

calloglfunc[obsgeno12_, fhaploprior12_, ismaleX_,priortrancode_,priortranset_] :=
    Module[ {ls, count},
        ls = Tally[Transpose[Join[obsgeno12, {ismaleX, priortrancode}]]];
        count = ls[[All, 2]];
        ls = Transpose[Round[basiclogl[Sequence @@ fhaploprior12[[All,1]], Sequence @@ #] & /@ ls[[All, 1]], 10^(-10.)]];
        Evaluate[Total[Log[Total[ls #^Range[0, Length[ls] - 1]]] count]+Log[Times@@fhaploprior12[[All,2]]]] &
    ]

(*only for indepModel and depModel*)
findFractionMLE[loglfunc_Function,lowbound_,upbound_,precisiongoal_, accuracygoal_,itmax_] :=
    Module[ {xls, fls, rmax, loglrmax, his,loglupbound,r},
        If[ TrueQ[loglfunc[r]===loglfunc[0]],
            rmax = "Noninformative";
            loglupbound = loglrmax = loglfunc[rmax];
            his = {{rmax, loglrmax}};
            his = Join[List /@ Range[Length[his]], his, 2],
            {rmax, loglrmax, his} = brentLocalMax[loglfunc, Automatic,lowbound, upbound, 
              AccuracyGoal -> accuracygoal, PrecisionGoal -> precisiongoal,MaxIterations->itmax];
            xls = {lowbound, upbound};
            fls = loglfunc[#] & /@ xls;
            Which[
                 loglrmax < fls[[1]],
                 {rmax, loglrmax} = {xls[[1]], fls[[1]]};
                 AppendTo[his, {Length[his] + 1, rmax, loglrmax}],
                 loglrmax < fls[[-1]], 
                 {rmax, loglrmax} = {xls[[-1]], fls[[-1]]};
                 AppendTo[his, {Length[his] + 1, rmax, loglrmax}]
            ];
            loglupbound = fls[[-1]];
        ];
        {rmax, loglupbound,loglrmax,his}
    ]    
    
(*
An example results with two modes of recomfrequencies: 0.329 and 0.693, 
whre 0.329 is the maximum because it has larger likelihood after integrating phases. 
{
 {34, 60, 0.693075, -1371.92, -1364.89, 8},
 {34, 61, 0.693075, -1371.92, -1364.89, 8},
 {34, 86, 0.693075, -1371.92, -1364.89, 8},
 {34, 51, 0.329225, -1371.92, -1364.89, 7},
 {34, 57, 0.329225, -1371.92, -1364.89, 7},
 {34, 76, 0.329225, -1371.92, -1364.89, 7},
 {34, 77, 0.329225, -1371.92, -1364.89, 7},
 {34, 81, 0.329225, -1371.92, -1364.89, 7},
 {34, 83, 0.329225, -1371.92, -1364.89, 7},
 {34, 73, 0.875, -1371.92, -1371.92, 26},
 {34, 63, 0.662408, -1384.72, -1377.88, 8},
 {34, 88, 0.662408, -1384.72, -1377.88, 8},
 {34, 89, 0.662408, -1384.72, -1377.88, 8},
 {34, 79, "Noninformative", -1384.72, -1384.72, 1},
 {34, 85, "Noninformative", -1384.72, -1384.72, 1},
 {33, 51, 0.632313, -1394.61, -1389.58, 7}
 ...
}
*)    
    
findFractionMLE[obsgeno12_, fhaploprior12list_, maxfraction_, ismaleX_, 
  priortrancode_,priortranset_,precisiongoal_, accuracygoal_, itmax_] :=
    Module[ {prior1, prior2,fhaploprior12, loglfunc, res, lowbound = 0, 
      rmax, loglupbound, loglrmax, his,k,l},
        {prior1, prior2} = fhaploprior12list;
        res = Table[
          fhaploprior12 = {prior1[[k]], prior2[[l]]};
          loglfunc = calloglfunc[obsgeno12, fhaploprior12, ismaleX, priortrancode,priortranset];
          (*Print["{prior1,prior2,k,l,loglfunc[x]} = ",{prior1,prior2,k,l,loglfunc}];*)
          {rmax, loglupbound, loglrmax, his} =  findFractionMLE[loglfunc, lowbound, maxfraction, precisiongoal, accuracygoal, itmax];
          Join[fhaploprior12[[All,1]],{rmax, loglupbound, loglrmax, Length[his]}], {k, Length[prior1]}, {l, Length[prior2]}];
        res = Flatten[res, 1];
        loglupbound = Max[res[[All, 4]]];
        loglrmax = Max[res[[All, 5]]];
        res = Select[res, (#[[5]] == loglrmax &)];
        rmax = Min[Commonest[res[[All, 3]]]];
        res = Select[res, (#[[3]] == rmax &)];
        {res[[All, ;; 2]], rmax, (loglrmax - loglupbound) Log[10,E], loglrmax}
    ]
  
basiclogl[fhaplocode1_, fhaplocode2_, geno1_, geno2_, ismalex_, priorcode_] /; fhaplocode1 > fhaplocode2 :=
    basiclogl[fhaplocode1, fhaplocode2, geno1, geno2, ismalex,priorcode] = 
     basiclogl[fhaplocode2, fhaplocode1, geno2, geno1, ismalex, priorcode]
  
basiclogl[fhaplocode1_, fhaplocode2_, geno1_, geno2_, ismalex_,priorcode_] /; fhaplocode1 <= fhaplocode2 :=
    basiclogl[fhaplocode1, fhaplocode2, geno1, geno2, ismalex, priorcode] = 
     calbasiclogl[fhaplocode1, fhaplocode2, geno1, geno2, ismalex, priorcode, basicloglconst]

calInterSNPsimilarity[roughMap_, magicSNP_, model_, popDesign_, epsF_,
   eps_, minphredscore_, foundercallthreshold_, isfounderinbred_, isfounderdepth_, isoffspringdepth_, isprint_] :=
    Module[ {maxfoundererror = 0, precisiongoal = 10, accuracygoal = 10,itmax = 100, fractionupbound = 1, qualityscore = 30, 
      genothreshold = 0.95, lowlodbound = 1,morganrate, snpid, fhaploset, founderhaplorule, obsgeno, priortrancode, priortranset, ismaleX, 
      interpairs, fractions, res,ij,lg},
        {morganrate, snpid, fhaploset, founderhaplorule, obsgeno,priortrancode, priortranset, ismaleX} = 
         mapPreprocessing[magicSNP, model, popDesign, epsF, minphredscore,maxfoundererror, foundercallthreshold, isfounderinbred, isfounderdepth, isoffspringdepth, isprint];
        basicloglconst = {priortranset, founderhaplorule, model, epsF, eps,minphredscore, isoffspringdepth};
        removeDownValues[basiclogl[_?IntegerQ, _?IntegerQ, ___]];
        If[ isoffspringdepth,
            obsgeno = rawGenotypeCall[obsgeno, qualityscore,genothreshold] /. {"21" -> "12"};
        ];
        interpairs = DeleteCases[Join[List /@ Range[Length[roughMap] - 1],roughMap[[2 ;;, 2 ;; 5]], 2], {_, "ungrouped", ___}];
        interpairs = SplitBy[interpairs, #[[2]] &];
        interpairs[[All, 2 ;;, 5]] = Partition[#, 2, 1] & /@ interpairs[[All, All, 5]];
        interpairs[[All, 1, 5]] = "NA";
        Do[
         fractions = Table[findFractionMLE[obsgeno[[ij]], fhaploset[[ij]],fractionupbound, ismaleX, priortrancode, priortranset, 
            precisiongoal, accuracygoal, itmax], {ij, interpairs[[lg, 2 ;;, 5]]}];
         fractions = fractions[[All, 2]] Boole[Thread[fractions[[All, 3]] > lowlodbound]];
         interpairs[[lg, 2 ;;, 4]] = fractions;
         interpairs[[lg, All, 3]] = Join[{0}, Accumulate[-Log[1 - fractions]/morganrate] 100];
         0, {lg, Length[interpairs]}];
        interpairs = Flatten[interpairs, 1];
        If[ isprint,
            Print["Genetic map function for initial map construction: scaled fraction = 1-Exp[-"<>ToString[N[Round[morganrate,10^(-2)]]]<>" distance(M)]"];
        ];
        res = roughMap;
        res[[interpairs[[All, 1]] + 1, {3, 4}]] = interpairs[[All, {3, 4}]];
        res
    ]
  

    
calsimilarity[magicSNP_,  model_, popDesign_,epsF_, eps_,rowspan_,similartype_,outputfile_,precisiongoal_, accuracygoal_, itmax_,lodbound_,
    minphredscore_, maxfoundererror_, foundergenocallbound_,isfounderinbred_, isfounderdepth_, isoffspringdepth_,isprint_] :=
    Module[ {starttime,snpid,fhaploset, founderhaplorule,obsgeno, priortrancode, priortranset,ismaleX,bool,count,totcount,
        res,i,j,k,ii,jj,missingcode,ls,outstream,nsnp,fractionupbound = 1,morganrate,calledgeno, qualityscore, genothreshold},
        If[ isprint,
            starttime = SessionTime[];
        ];
        (*Put[magicSNP, model, popDesign, epsF, minphredscore,maxfoundererror, foundergenocallbound, 
                                isfounderinbred,isfounderdepth, isoffspringdepth, isprint,"temp.txt"];
        Abort[];*)
        {morganrate,snpid,fhaploset, founderhaplorule,obsgeno, priortrancode, priortranset, ismaleX} = 
            mapPreprocessing[magicSNP, model, popDesign, epsF, minphredscore,maxfoundererror, foundergenocallbound, 
                                isfounderinbred,isfounderdepth, isoffspringdepth, isprint];
        basicloglconst = {priortranset, founderhaplorule,model, epsF, eps, minphredscore,isoffspringdepth};
        removeDownValues[basiclogl[_?IntegerQ, _?IntegerQ, ___]];
        Quiet[Close[outputfile]];
        Put[outputfile];
        outstream = OpenWrite[outputfile];
        nsnp = Length[fhaploset];
        ii = Range[nsnp-1][[rowspan]];
        If[ First[ii]==1,
            If[ MatchQ[similartype,"independence"],
                founderhaplorule = Missing["NotApplicable"]
            ];
            Write[outstream, {{"SimilarityType",similartype},{"MinLodSaving",lodbound},{"MorganRate",morganrate},
                              {"SNPName",snpid},{"isFounderInbred",isfounderinbred},{"FounderHaplotypeRule",founderhaplorule}}];
            Write[outstream, Transpose[{{"founderAllelicError", "offspringAllelicError","minPhredQualScore",  "priorFounderCallThreshold", 
                                         "isFounderAllelicDepth","isOffspringAllelicDepth", "PrecisionGoal", "AccuracyGoal", "MaxIterations","outputFile"}, 
                                        {epsF, eps,minphredscore, foundergenocallbound,
                                          isfounderdepth,isoffspringdepth, precisiongoal, accuracygoal, itmax,outputfile}}]];
            Switch[similartype,
                "linkage",
                Write[outstream, {"SNP1", "SNP2", "FounderHaplotype", "RecombinationFraction", "LinkageLOD", "LinkageMaxLogl"}],
                "independence",
                Write[outstream, {"SNP1", "SNP2", "G2Statistic", "DegreeOfFreedom", "-Log10PValue", "IndependenceLod"}],
                "both",
                Write[outstream, {"SNP1", "SNP2", "G2Statistic", "DegreeOfFreedom", "-Log10PValue", "IndependenceLod","FounderHaplotype", "RecombinationFraction", "LinkageLOD", "LinkageMaxLogl"}],
                _,
                Print["Similarity type must be \"independence\" or \"linkage\"!"];
                Abort[];
            ];
        ];
        If[ isoffspringdepth,
            qualityscore = 30;
            genothreshold = 0.95;
            calledgeno = rawGenotypeCall[obsgeno, qualityscore, genothreshold]/. {"21" -> "12"},
            calledgeno = obsgeno/. {"21" -> "12"};
        ];
        bool = ii[[{1,-1}]]==={1,nsnp-1};
        totcount = Total[ii];
        count = 0;
        Do[ 
            (*PrintTemporary["Kernel = ", $KernelID,". i = ",i];*)
            jj = Range[i + 1, nsnp];
            count +=nsnp-i;
            If[ MatchQ[similartype,"independence"|"both"],
                missingcode = "NN" | "N" | "1N" | "2N" | "N1" | "N2";
                ls = DeleteCases[Transpose[calledgeno[[Join[{i}, jj]]]], {missingcode, __}];
                ls = Table[crossTabulate[DeleteCases[ls[[All, {1, k}]], {_, missingcode}]], {k, 2, Length[jj] + 1}];
                res = independenceGTest[ls[[All, 1]]];
                If[ Head[res]===independenceGTest,
                    Print["Wrong inputdata for independence G-Test!,inputdata = ",ls[[All, 1]]];
                    Abort[];
                ];
                res = Join[Thread[{i, jj}], res, 2];
                res = DeleteCases[res,_?(#[[6]]<=lodbound&)];
                jj = res[[All,2]],
                res = Thread[{i, jj}]
            ];
            If[ MatchQ[similartype,"linkage"|"both"]&&jj=!={},
                res = Join[res,Table[findFractionMLE[obsgeno[[{i,j}]], fhaploset[[{i,j}]], fractionupbound, ismaleX, 
                            priortrancode, priortranset,precisiongoal, accuracygoal, itmax], {j,jj}],2];
                res = DeleteCases[res,_?(#[[-2]]<=lodbound&)];
                If[ res=!={},
                    res[[All,-3;;]] = N[Round[res[[All,-3;;]],10^(-5)]]/.{_Round -> "Noninformative"};
                ];
            ];
            If[ res=!={},
                Write[outstream, #] & /@ res;
            ];
            If[ bool&&(Mod[i,10]==0),
                PrintTemporary["Time elapsed = ", Round[SessionTime[]-starttime,0.01]," seconds. #row = ", i, " out of ",nsnp-1,
                    ". #pairs = ", count, " out of ", totcount];
            ], {i,ii}];
        Close[outstream];
        removeDownValues[basiclogl[_?IntegerQ, _?IntegerQ, ___]];
    ]
  
getrowspan[nsnp_, nseg_] :=
    Module[ {ls, ls2},
        ls = Accumulate[Range[nsnp - 1, 1, -1]];
        ls2 = Round[Range[nseg - 1] Last[ls]/nseg];
        ls = Union[Join[Flatten[Position[ls - #, _?Positive, {1}, 1, Heads -> False] & /@ls2], {1, nsnp}]];
        Thread[Most[ls] ;; Rest[ls] - 1]
    ]

parallelsimilarity[magicSNP_, model_, popDesign_, epsF_, eps_,similartype_,outputfile_, precisiongoal_, accuracygoal_, itmax_, lodbound_, 
  minphredscore_, maxfoundererror_, foundergenocallbound_, isfounderinbred_, isfounderdepth_, isoffspringdepth_, isprint_] :=
    Module[ {filels, nsnp, spanls, countls, count, outstream,i},
        nsnp = Length[magicSNP[[2]]] - 1;
        spanls = getrowspan[nsnp, Max[2,IntegerLength[nsnp]-1] $KernelCount];
        filels = "temporaryfile" <> ToString[#] <> ".txt" & /@ Range[Length[spanls]];
        filels[[1]] = outputfile;
        filels = FileNameJoin[{Directory[], #}]&/@filels;
        countls = Range[nsnp - 1, 1, -1];
        countls = Total[countls[[#]]] & /@ spanls;
        (*SetSharedVariable[count,spanls,countls,filels];*)
        SetSharedVariable[count];
        count = 0;
        (*Print["Number of temporary files: ",Length[filels]];*)
        Monitor[ParallelDo[
          calsimilarity[magicSNP,  model, popDesign,epsF, eps, spanls[[i]], similartype,filels[[i]], precisiongoal, accuracygoal, itmax, lodbound, 
           minphredscore, maxfoundererror, foundergenocallbound, isfounderinbred, isfounderdepth, isoffspringdepth, isprint];
          count += countls[[i]], {i, Length[filels]},
          DistributedContexts->{"MagicMap`", "MagicMap`Private`"},
          Method -> "FinestGrained"],
         ProgressIndicator[count, {0, Total[countls]}]];
        Quiet[Close[filels[[1]]]];
        outstream = OpenAppend[filels[[1]]];
        Do[Write[outstream, #] & /@ ReadList[filels[[i]]], {i, 2, Length[filels]}];
        Close[outstream];
        DeleteFile[#] & /@ Rest[filels];
    ]

calmagicibd[inputmagicSNP_, popDesign_, isfounderinbred_, isfounderdepth_, isoffspringdepth_] :=
    Module[ {ischrX, magicSNP = inputmagicSNP, deltd, founderHaplo, 
      obsGeno, snpMap, haploMap, nFounder, posA, posX, foundergender, 
      offspringgender, founderid, sampleid, samplelabel, i,
      continuedMarkovProcess, temp, nfgl, geno, pos, ibdprob},
        ischrX = False;
        magicSNP[[3, 2 ;;]] = If[ ischrX,
                                  "x",
                                  1
                              ];
        magicSNP[[4, 2 ;;]] = Range[Length[magicSNP[[4, 2 ;;]]]];
        SNPValidation[magicSNP, isfounderinbred, isfounderdepth, isoffspringdepth];
        {deltd, founderHaplo, obsGeno, snpMap, haploMap, nFounder, posA, posX, foundergender, offspringgender, founderid, sampleid} = 
         transformMagicSNP[magicSNP, isfounderinbred, isfounderdepth, isoffspringdepth];
        {samplelabel, continuedMarkovProcess} = sampleContinuedPriorProcess[nFounder, popDesign, isfounderinbred, 
          "jointModel", posA, posX, offspringgender, sampleid];
        temp = Normal[continuedMarkovProcess[[All, 2, 1, 1]]];
        nfgl = Sqrt[Max[Length[#] & /@ temp]];
        temp = Select[temp, Length[#] == nfgl^2 &];
        geno = origGenotype[nfgl][[1, 2]];
        pos = Flatten[Position[geno, {i_, i_}]];
        ibdprob = Mean[Total[#] & /@ temp[[All, pos]]];
        ibdprob
    ]
     
(*Keep minLodSaving<=Min(minLodClustering,minLodOrdering)*)     
Options[magicPairwiseSimilarity] = {
    founderAllelicError -> 0.005,
    offspringAllelicError -> 0.005,  
    isFounderInbred -> True,
    computingLodType -> "both",
    sequenceDataOption ->{
        isFounderAllelicDepth -> Automatic,
        isOffspringAllelicDepth -> Automatic,
        minPhredQualScore -> 30,
        priorFounderCallThreshold -> 0.99
        },
    outputFileID -> "", 
    isPrintTimeElapsed ->True,
    isRunInParallel -> True,
    minLodSaving ->1
}
        
magicPairwiseSimilarity[inputmagicSNP_?(ListQ[#] || StringQ[#] &),inputmodel_String,inputpopDesign_?(ListQ[#] || StringQ[#] &), opts : OptionsPattern[]] :=
    Module[ {starttime,nfounder,magicSNP = inputmagicSNP, model = inputmodel,popDesign = inputpopDesign,epsF,eps,ibdprob,
        lodtype,outputfile,outputid,isprint,isparallel,minphredscore,maxfoundererror = 0,lodbound,
        foundergenocallbound,isfounderinbred,isfounderdepth,isoffspringdepth, precisiongoal = 10, accuracygoal = 10, itmax = 100},
        {epsF,eps} = OptionValue@{founderAllelicError,offspringAllelicError};
        {isfounderdepth,isoffspringdepth,minphredscore,foundergenocallbound} =
            OptionValue[Thread[sequenceDataOption -> {isFounderAllelicDepth,isOffspringAllelicDepth,minPhredQualScore,priorFounderCallThreshold}]];
        {isfounderinbred,lodtype,lodbound,outputid,isprint,isparallel} = 
            OptionValue@{isFounderInbred,computingLodType,minLodSaving,outputFileID,isPrintTimeElapsed,isRunInParallel};
        If[ StringQ[lodtype],
            lodtype = ToLowerCase[lodtype];
        ];
        If[ !MemberQ[{"independence","linkage","both"},lodtype],
            Print["magicPairwiseSimilarity: wrong similarityType \"",lodtype, "\". similarityType must be \"independence\",\"linkage\", or \"both\"!"];
            Abort[]
        ];
        If[ outputid=!="",
            outputid = outputid<>"_"
        ];
        outputfile = outputid <> "pairwiseSimilarity.txt";
        If[ !MemberQ[{"jointModel","indepModel","depModel"},model],
            Print["magicPairwiseSimilarity: model has to take \"jointModel\", \"indepModel\", or \"depModel\"."];
            Return[$Failed]
        ];
        If[ StringQ[magicSNP],
            If[ !FileExistsQ[magicSNP],
                Print["File ", magicSNP," does not exist!"];
                Return[$Failed]
            ];
            magicSNP = Import[magicSNP,"CSV"];
        ];
        If[ MatchQ[magicSNP[[3, -1]], "X" | "x"],
            magicSNP[[3, 2 ;;]] = magicSNP[[3, -1]],
            magicSNP[[3, 2 ;;]] = "NA"
        ];
        magicSNP[[4, 2 ;;]] = "NA";
        If[ StringQ[popDesign],
            If[ !FileExistsQ[popDesign],
                Print["File ", popDesign," does not exist!"];
                Return[$Failed]
            ];
            popDesign = Import[popDesign,"CSV"];
        ];
        If[ isprint,
            starttime = SessionTime[];
            Print["magicPairwiseSimilarity. Start date = ", DateString[], ". Outputfile = ",outputfile];
            nfounder = magicSNP[[1, 2]];
            Print["{#founder, #offspring, #SNP} =",Prepend[ Dimensions[Rest[magicSNP]] - {nfounder + 3, 1}, nfounder]];
        ];
        {isfounderdepth, isoffspringdepth} = checkOptionValue[magicSNP, isfounderdepth, isoffspringdepth,isfounderinbred, isprint];
        (*Put[magicSNP, model, popDesign, epsF, eps,lodtype,outputfile,precisiongoal, accuracygoal, itmax,lodbound,
                    minphredscore, maxfoundererror, foundergenocallbound,isfounderinbred, isfounderdepth, isoffspringdepth,isprint,"temp.txt"];
         *)
        If[ ToLowerCase[model]==="jointmodel"&&(lodtype=!="independence"),
            ibdprob = calmagicibd[magicSNP, popDesign, isfounderinbred, isfounderdepth,isoffspringdepth];
            model = If[ ibdprob>0.85,
                        "depModel",
                        "indepModel"
                    ];
            If[ isprint,
                Print["model is set to \"",model, "\" since the IBD probability = ",ibdprob, If[ ibdprob>0.85,
                                                                                                 "(>0.85)!",
                                                                                                 "(<=0.85)!"
                                                                                             ]];
            ];
        ];            
        If[ isparallel,
            parallelsimilarity[magicSNP, model, popDesign, epsF, eps, lodtype,outputfile, precisiongoal, accuracygoal, itmax, lodbound, 
                        minphredscore, maxfoundererror, foundergenocallbound, isfounderinbred,isfounderdepth, isoffspringdepth, isprint],
            calsimilarity[magicSNP, model, popDesign, epsF, eps,All,lodtype,outputfile,precisiongoal, accuracygoal, itmax,lodbound,
                    minphredscore, maxfoundererror, foundergenocallbound,isfounderinbred, isfounderdepth, isoffspringdepth,isprint]
        ];
        If[ isprint,
            Print["Done! Finished date =",DateString[], ". \tTime elapsed in total = ", Round[SessionTime[] - starttime,0.1], " Seconds."];
        ];
        outputfile
    ] 
    
(************************************************************************************************)    
(*linkage={"SNP1", "SNP2", "FounderHaplotype", "RecombinationFraction", "LinkageLOD", "LinkageMaxLogl"}*)
(*both={"SNP1", "SNP2", "G2Statistic", "DegreeOfFreedom", "-Log10PValue", "IndependenceLod",
"FounderHaplotype", "RecombinationFraction", "LinkageLOD", "LinkageMaxLogl"}*)           
readPairwiseDatafile[datafile_?FileExistsQ] :=
    Module[ {ressimilarity,lodtype, minlodsaving,snpid,isfounderinbred,fphaserule,nsnp, morganrate, rule, 
        rfmtx, linklodmtx,indeplodmtx},
        rfmtx = linklodmtx = indeplodmtx = Missing["NotAvailable"];
        ressimilarity = ReadList[datafile];
        {lodtype, minlodsaving, morganrate, snpid, isfounderinbred,fphaserule} = ressimilarity[[1, All,2]];
        lodtype = ToLowerCase[lodtype];
        nsnp = Length[snpid];
        ressimilarity = ressimilarity[[4;;]];
        If[ MatchQ[lodtype,"independence"|"both"],
            rule = ressimilarity[[All, ;; 2]] -> ressimilarity[[All, 6]];
            rule = Join[{{i_, i_} -> Infinity}, Thread[rule]];
            indeplodmtx = SparseArray[rule, {nsnp, nsnp}];
            indeplodmtx += Transpose[indeplodmtx]
        ];
        If[ MatchQ[lodtype,"linkage"|"both"],
            ressimilarity[[All, -3]] = ressimilarity[[All, -3]] /. {"Noninformative" -> 1};
            rule = Join[Thread[ressimilarity[[All, ;; 2]] -> ressimilarity[[All, -3]]],
                Thread[(Reverse[#] & /@ ressimilarity[[All, ;; 2]]) ->ressimilarity[[All, -3]]]];
            rfmtx = SparseArray[rule, {nsnp, nsnp}, Max[ressimilarity[[All, -3]]]];
            rule = ressimilarity[[All, ;; 2]] -> ressimilarity[[All, -2]];
            rule = Join[{{i_, i_} -> Infinity}, Thread[rule]];
            linklodmtx = SparseArray[rule, {nsnp, nsnp}];
            linklodmtx += Transpose[linklodmtx];
        ];
        {lodtype,isfounderinbred,minlodsaving, morganrate, snpid, rfmtx, linklodmtx, indeplodmtx}
    ]

adjConnectedComponents[similarity_] :=
    ConnectedComponents[AdjacencyGraph[Abs[Sign[similarity]]]]

(*knn+1 to account for the self neighbor*)        
toSparseIndicatorKnn[lodmtx_, minlod_,minlodmini_,knn_] :=
    SparseArray[Sign[(Boole[Positive[lodmtx - minlod]]+ Boole[Positive[lodmtx - minlodmini]] Boole[Positive[toKNNSimilarity[lodmtx, Min[Length[lodmtx]-1,knn] + 1]]])]]       

toSparseIndicator[lodmtx_, minlod_, minlodmini_, miniclustersize_] :=
    Module[ {aa, components, len, temp, microclusters},
        aa = SparseArray[Boole[Positive[lodmtx - minlod]]];
        components = adjConnectedComponents[aa];
        If[ Length[components] > 1 && minlod > minlodmini,
            len = Sign[(Length[#] & /@ components) - miniclustersize - 1];
            microclusters = Union[Flatten[Pick[components, len, -1]]];
            temp = SparseArray[Boole[Positive[lodmtx - minlodmini]]];
            aa[[microclusters]] = temp[[microclusters]];
            aa[[All, microclusters]] = temp[[All, microclusters]];
        ];
        aa
    ]
     
fractiontosimilarity[rfmtx_, maxrf_] :=
    Module[ {aa},
        If[ maxrf===Automatic,
            aa = 1-rfmtx/Max[rfmtx],
            aa = 1-rfmtx/maxrf;
            aa*=Boole[Positive[aa]];            
        ];
        aa=(aa-Min[aa])/(Max[aa]-Min[aa]);
        (*to comare loc when fraction is the same, using temp=aa+lod/Max[lod] 10^(-6)*)
        Round[aa, 10^(-5.)]
    ]
  

toLinkageSimilarity[rfmtx_, maxrf_, lodmtx_, minlod_] :=
    toLinkageSimilarity[rfmtx, maxrf, lodmtx, minlod, minlod,0]

toLinkageSimilarity[rfmtx_, maxrf_, lodmtx_, minlod_, minlodmini_,miniclustersize_] :=
    fractiontosimilarity[rfmtx, maxrf] toSparseIndicator[lodmtx, minlod, minlodmini, miniclustersize]    
                
toLinkageNNSimilarity[rfmtx_, maxrf_, lodmtx_, minlod_,minlodmini_,knn_] :=
    fractiontosimilarity[rfmtx, maxrf] toSparseIndicatorKnn[lodmtx, minlod, minlodmini,knn]        
    
toLodSimilarity[lodmtx_, minlod_] :=
    toLodSimilarity[lodmtx, minlod,minlod,0]
    
toLodSimilarity[lodmtx_, minlod_, minlodmini_,miniclustersize_] :=
    Module[ {aa},
        aa = SparseArray[lodmtx toSparseIndicator[lodmtx, minlod, minlodmini, miniclustersize]];
        aa *= 1 - IdentityMatrix[Length[aa]];
        aa += SparseArray[DiagonalMatrix[((Max[#] & /@ aa) /. {0 | 0. -> Max[aa]})]];
        aa
    ]       
        
toLodNNSimilarity[lodmtx_, minlod_, minlodmini_,knn_] :=
    Module[ {aa},
        aa = SparseArray[lodmtx toSparseIndicatorKnn[lodmtx, minlod,minlodmini,knn]];
        aa *= 1 - IdentityMatrix[Length[aa]];
        aa += SparseArray[DiagonalMatrix[((Max[#] & /@ aa) /. {0 | 0. -> Max[aa]})]];
        aa
    ]   
          
dropMinicluster[similarity_,miniclustersize_,isprint_:True] :=
    Module[ {components, len, singlevertices, connectedvertices},
        components = adjConnectedComponents[similarity];
        len = Length[#] & /@ components;
        If[ isprint,
            Print["Size of "<>ToString[Length[len]]<>" connected componets: ", Sort[len,Greater], "; dropping components with size <= ",miniclustersize,"!"];
        ];
        singlevertices = Sort[Flatten[Pick[components, Sign[len - miniclustersize-1], -1]]];
        connectedvertices = DeleteCases[Range[Length[similarity]], _?(MemberQ[singlevertices, #] &)];
        {similarity[[connectedvertices, connectedvertices]], connectedvertices, singlevertices}
    ]   
    
Options[magicGrouping] = Join[{miniComponentSize->5,isPrintTimeElapsed ->True},Options[spectralClustering]]
    
magicGrouping[similarity_,ngroup_,opts : OptionsPattern[]] :=
    Module[ {miniclustersize,isprint,similarity2, connectedvertices, linkagegroups, singletons, eigenval, eigenvec},
        {miniclustersize,isprint} = OptionValue@{miniComponentSize,isPrintTimeElapsed};
        If[ ngroup===1,
            {{Range[Length[similarity]]}, {},Missing["NotAvailable"],Missing["NotAvailable"]},
            {similarity2, connectedvertices, singletons} = dropMinicluster[similarity,miniclustersize,isprint];  
            {linkagegroups, eigenval, eigenvec} = spectralClustering[similarity2, ngroup,FilterRules[{opts}, Options[spectralClustering]]];
            linkagegroups = connectedvertices[[#]] & /@ linkagegroups;
            eigenvec = Thread[connectedvertices->Transpose[eigenvec]];
            {linkagegroups, singletons, eigenval, eigenvec}
        ]
    ]   
    
                
formeigenspectral[estorder_,singletons_,eigenval_,eigenvec_] :=
    Module[ {eigenspectral,eigenhead},
        eigenspectral = Round[(Flatten[estorder] /. eigenvec), 10^(-5.)];
        eigenhead = Map[ToString, Round[eigenval, 10^(-5.)], {2}];
        eigenhead = Flatten[Map["Eigenvec_eigenval" <> ToString[#] &, eigenhead, {2}]];
        eigenspectral = Join[{eigenhead},eigenspectral,ConstantArray["NA",{Length[singletons],Length[eigenhead]}]];
        eigenspectral
    ]  

formRoughMap[snpid_, neighbors_, neighborstrengths_,neighborlods_, estorder_,singletons_, eigenval_,eigenvec_,rfmtx_,morganrate_] :=
    Module[ {markerid, res, pairs, colname, ff,dd,lg,nals,eigenspectral},
        If[ !MissingQ[eigenval],
            eigenspectral = formeigenspectral[estorder,singletons,eigenval,eigenvec];
        ];
        markerid = snpid[[#]] & /@ estorder;
        res = Table[
          pairs = Partition[estorder[[lg]], 2, 1];
          ff = Extract[rfmtx, pairs];
          dd = -Log[1 - ff]/morganrate;
          dd = Join[{0},Accumulate[100 dd]];
          Transpose[{markerid[[lg]], Table[lg, {Length[pairs] + 1}], dd, Join[{"NA"},ff],
              estorder[[lg]],neighbors[[estorder[[lg]]]], neighborstrengths[[estorder[[lg]]]],neighborlods[[estorder[[lg]]]]}], {lg, Length[estorder]}];
        colname = {"MarkerID", "LinkageGroupNo", "Position(cM)", "InterMarkerFraction", "InputMarkerNo","NearestNeighbor","NeighborSimilarity","NeighborLod"};
        nals = Table["NA", {Length[singletons]}];
        res = Join[res,{Transpose[{snpid[[singletons]], Table["ungrouped", {Length[singletons]}],nals,nals, 
            singletons,neighbors[[singletons]],neighborstrengths[[singletons]],neighborlods[[singletons]]}]}];
        res = Join[{colname}, Flatten[res, 1]];
        If[ MissingQ[eigenval],
            res,
            Join[res,eigenspectral,2]
        ]
    ]  

formRoughMap[snpid_, neighbors_, neighborstrengths_,neighborlods_,estorder_,singletons_,eigenval_,eigenvec_] :=
    Module[ {markerid, res, pairs, colname, nals,lg,eigenspectral},
        eigenspectral = formeigenspectral[estorder,singletons,eigenval,eigenvec];
        markerid = snpid[[#]] & /@ estorder;
        res = Table[
          pairs = Partition[estorder[[lg]], 2, 1];
          Transpose[{markerid[[lg]], Table[lg, {Length[pairs] + 1}], Table["NA",{Length[pairs] + 1}],Table["NA",{Length[pairs] + 1}],
              estorder[[lg]],neighbors[[estorder[[lg]]]],neighborstrengths[[estorder[[lg]]]],neighborlods[[estorder[[lg]]]]}], {lg,Length[estorder]}];
        colname = {"MarkerID", "LinkageGroupNo","Position(cM)","InterMarkerFraction",  "InputMarkerNo","NearestNeighbor","NeighborSimilarity","NeighborLod"};
        nals = Table["NA", {Length[singletons]}];
        res = Join[res,{Transpose[{snpid[[singletons]], Table["ungrouped", {Length[singletons]}],nals,nals, 
            singletons,neighbors[[singletons]],neighborstrengths[[singletons]],neighborlods[[singletons]]}]}];
        res = Join[{colname}, Flatten[res, 1]];
        Join[res,eigenspectral,2]
    ]      

relabelLinkagegroup[snpid_,linkagegroups_,inputrefmap_] :=
    Module[ {refmap},
        If[ inputrefmap===None,
            linkagegroups,
            refmap = inputrefmap;
            refmap = SplitBy[Join[refmap[[2 ;;, ;; 2]], List /@ Range[Length[refmap] - 1],2], #[[2]] &];
            refmap = Map[Rule @@ # &, refmap[[All, All, {1, 3}]], {2}];
            linkagegroups[[Ordering[Median[#] & /@ ((snpid[[#]] & /@ linkagegroups) /.Flatten[refmap])]]]
        ]
    ]
  
checklodtype[computedtype_,clusterlodtype_,orderlodtype_,pairwisedatafile_] :=
    Module[ {},
        If[ MatchQ[computedtype,"both"],
            If[ !MemberQ[{"independence","linkage","both"},clusterlodtype],
                Print["magicMapConstruct: wrong lodTypeClustering ",clusterlodtype, ". lodTypeClustering must be \"independence\",\"linkage\", or \"both\"!"];
                Abort[];
            ];
            If[ !MemberQ[{"independence","linkage","both"},orderlodtype],
                Print["magicMapConstruct: wrong lodTypeOrdering ",clusterlodtype, ". lodTypeOrdering must be \"independence\",\"linkage\", or \"both\"!"];
                Abort[];
            ],
            If[ clusterlodtype=!=computedtype,
                Print["magicMapConstruct: lodTypeClustering optionvalue \"", clusterlodtype, 
                    "\" is not compatible with the computingLodType \"", computedtype, "\" in ",pairwisedatafile, 
                    ". clusterlodtype is reset to \"",computedtype,"\"!"];
                clusterlodtype = computedtype
            ];
            If[ clusterlodtype=!=computedtype,
                Print["magicMapConstruct: lodTypeOrdering optionvalue \"", orderlodtype, 
                    "\" is not compatible with the computingLodType \"", computedtype, "\" in ",pairwisedatafile, 
                    ". lodTypeOrdering is reset to \"",computedtype,"\"!"];
                orderlodtype = computedtype
            ];
        ];
    ]  

(*maxScaledRF::usage = "maxScaledRF is an option to specify the maximum recombination fraction as threshold for linkage grouping"
*)      
Options[magicMapConstruct] = DeleteDuplicates[Join[Options[magicGrouping],Options[spectralOrdering],
      {miniComponentSize->5,
      nConnectedComponent->1,
      lodTypeClustering->"both",
      lodTypeOrdering->"both",      
      minLodClustering -> Automatic,  
      minLodOrdering -> Automatic,
      nNeighborFunction ->(Sqrt[#]&),
      nNeighborSaving -> 10,  
      referenceMap ->None,
      (*SCL: Strongest Cross Link: for each locus anotherl ocus is shown with wich it has the strongest linkage outside its own group*)   
      delStrongCrossLink->True,   
      outputFileID -> "",
      isPrintTimeElapsed ->True}
  ]]

magicMapConstruct[pairwisedatafile_?FileExistsQ, ngroup_Integer?Positive,opts : OptionsPattern[]] :=
    Module[ {clusterlodtype, evsel,orderlodtype,computedtype,minlodsaving,snpid, maxrf = 1,morganrate, rfmtx, linklodmtx, indeplodmtx,ii,jj,k,ls,miniclustersize,
       similarity, linkagegroups, singletons, eigenval, eigenvec, neighborstrength,neighborlod,neighbors,isfounderinbred,knnls,knnsnp,strongneighbors,knn,
      minlodclustering, minlodordering,knnfun,knnsaving,refmap,outputid, isprint,estmap,estorder,outputfile,starttime,temp,maxnconn,delscl},
        {delscl,maxnconn,clusterlodtype,orderlodtype,minlodclustering, minlodordering,knnfun,knnsaving,miniclustersize,refmap,outputid,isprint} = 
            OptionValue@{delStrongCrossLink,nConnectedComponent,lodTypeClustering,lodTypeOrdering,minLodClustering,minLodOrdering,nNeighborFunction,nNeighborSaving,miniComponentSize,referenceMap,outputFileID,isPrintTimeElapsed};
        {clusterlodtype,orderlodtype} = ToLowerCase[#]&/@{clusterlodtype,orderlodtype};
        evsel=OptionValue[eigenVectorSelection];
        maxnconn=Min[maxnconn,ngroup];
        If[ outputid =!= "",
            outputid = outputid <> "_"
        ];
        outputfile = outputid <> "initialLinkageMap.csv";
        If[ isprint,
            starttime = SessionTime[];
            Print["magicMapConstruct. Start date = ", DateString[], ". Outputfile = ",outputfile];
        ];
        {computedtype,isfounderinbred,minlodsaving, morganrate, snpid, rfmtx, linklodmtx, indeplodmtx} = readPairwiseDatafile[pairwisedatafile];
        computedtype = ToLowerCase[computedtype];
        checklodtype[computedtype,clusterlodtype,orderlodtype,pairwisedatafile];
        minlodsaving = Max[0,minlodsaving];
        If[ refmap=!=None,
            If[ StringQ[refmap]&&FileExistsQ[refmap],
                refmap = Import[refmap, Path -> Directory[]];
                temp = Complement[snpid, refmap[[2 ;;, 1]]];
                If[ temp =!= {},
                    Print["Markers in pairwise datafile are not in reference map: ",temp, ". referenceMap is reset to None!"];
                    refmap = None;
                ],
                Print["magicMapConstruct: file ", refmap," does not exist"];
                Abort[];
            ];
        ];
        (*Spectral clustering*)
        (*Put[{clusterlodtype, indeplodmtx,linklodmtx, rfmtx, maxrf, minlodsaving, minlodclustering, miniclustersize,maxnconn},"tempbrent.txt"];*)
        minlodclustering = findminlodBrent[clusterlodtype, indeplodmtx,linklodmtx, rfmtx, maxrf, minlodsaving, minlodclustering, miniclustersize,maxnconn];        
        similarity = getSimilarity[clusterlodtype, indeplodmtx,linklodmtx, rfmtx, maxrf, minlodclustering,Infinity,miniclustersize];
        (*Put[similarity,"temp_sim.txt"];*)
        {linkagegroups, singletons, eigenval, eigenvec} = magicGrouping[similarity,ngroup,FilterRules[{opts}, Options[magicGrouping]]];
        If[ OptionValue[minLodClustering]===Automatic,
            If[ isprint,
                Print[Style["The option value of minLodClustering is set to " <>ToString[minlodclustering] <> "!", {Black}]];
            ]
        ];
        If[ Count[Flatten[eigenval], _?(# < 10^(-10) &)]>ngroup,
            Print[Style["magicMapConstruct warning: the number " <> ToString[Count[Flatten[eigenval], _?(# < 10^(-10) &)]] <> 
                  " of clusters determined by multiplicity of zero eigenvalue > input #linkagegroup " <> ToString[ngroup] <> "!" <> 
                  " Try smaller option value of minLodClustering!", Red]];
        ];
        linkagegroups = relabelLinkagegroup[snpid,linkagegroups,refmap];
        If[ isprint,
            Print["Size of groups = ", Length[#] & /@ linkagegroups," and #ungrouped markers = ", Length[singletons]," after spectral clustering!",
                "Time elapsed in total = ", Round[SessionTime[] - starttime,0.1], " Seconds."];
        ];
        If[ delscl,
            strongneighbors = getStrongestNeighbors[clusterlodtype, linklodmtx, indeplodmtx,minlodclustering, miniclustersize];
            k = Length[singletons];
            {linkagegroups,singletons} = removewronglinkednode[linkagegroups, singletons, strongneighbors];
            If[ isprint&&k!=Length[singletons],
                Print["Size of groups = ", Length[#] & /@ linkagegroups," and #ungrouped markers = ", Length[singletons]," after removing markers whose strongest neighbors are not in the same group!"];
            ];
        ];        
        (*Spectral ordering*)
        If[ OptionValue[minLodOrdering]===Automatic,
            minlodordering = Table[
                temp = getSimilarity[orderlodtype, indeplodmtx[[ii, ii]],linklodmtx[[ii, ii]], rfmtx[[ii, ii]], 
                            maxrf,minlodclustering, minlodsaving,miniclustersize];
                temp = adjConnectedComponents[temp];
                temp = Count[(Length[#] & /@ temp) - miniclustersize, _?Positive];
                (**)
                If[ temp==1,
                    minlodclustering,
                    maxnconn = 1;
                    findminlodBrent[orderlodtype, indeplodmtx[[ii, ii]],linklodmtx[[ii, ii]], rfmtx[[ii, ii]], 
                                    maxrf, minlodsaving,Automatic, miniclustersize,maxnconn]
                ], {ii, linkagegroups}];
            If[ isprint,
                Print[Style["The option value of minLodOrderingng is set to " <>ToString[minlodordering] <> "!", {Black}]];
            ],
            Which[
                VectorQ[minlodordering, Positive] && 
                Length[minlodordering] >= Length[linkagegroups],
                minlodordering = Take[minlodordering, Length[linkagegroups]],
                TrueQ[Positive[minlodordering]],
                minlodordering = Table[minlodordering, {Length[linkagegroups]}],
                True,
                Print["magicMapConstruct: wrong minLodOrdering optionvalue: ",minlodordering,"!"];
                Abort[];
            ]
        ];
        knnls = Min[Length[#], Ceiling[knnfun[Length[#]]]] & /@ linkagegroups;
        (*Put[{orderlodtype,indeplodmtx,linklodmtx,rfmtx, maxrf,minlodordering,minlodsaving,miniclustersize,linkagegroups,knnls},"temp1.txt"];*)
        {similarity, linkagegroups, knnls,temp} = Transpose[Table[
            jj = linkagegroups[[ii]];
            temp = getSimilarity[orderlodtype, indeplodmtx[[jj, jj]], linklodmtx[[jj, jj]], rfmtx[[jj, jj]], maxrf, 
                      minlodordering[[ii]], minlodsaving, miniclustersize];
            knn = First[estimateKNN[temp, knnls[[ii]]]];
            temp = toKNNSimilarity[temp, knn];
            ls = adjConnectedComponents[temp];
            k = Positive[(Length[#] & /@ ls) - miniclustersize];
            ls = Sort[Flatten[Pick[ls, k, True]]];
            {temp[[ls, ls]], jj[[ls]], knn,Complement[jj, jj[[ls]]]}, {ii,Length[linkagegroups]}]];
        If[ isprint,
            Print["# NearestNeighbors = ",knnls];
        ];
        k = Length[singletons];
        singletons = Union[singletons, Flatten[temp]];
        If[ isprint&&k!=Length[singletons],
            Print["Size of groups = ", Length[#] & /@ linkagegroups," and #ungrouped markers = ", Length[singletons],
                " after dropping components with size <= ",miniclustersize, " for each group!"];
        ];
        estorder = MapThread[#2[[spectralOrdering[#1,FilterRules[{opts}, Options[spectralOrdering]]]]]&,{similarity,linkagegroups}];
        If[ isprint,
            If[ ngroup>1,
                ls = {spetralEigenPlot[eigenval,ngroup,evsel,isprint]},
                ls = {}
            ];
            If[ refmap=!=None,
                AppendTo[ls,Show[mymapplot[estorder, {"Estimated ordering", "Reference ordering"}, snpid, refmap]]]
            ];
            If[ ls=!={},
                Print[GraphicsRow[ls,ImageSize->550 Length[ls]]]
            ];
        ];
        knnsnp = Table[knnsaving, {Total[Length[#] & /@ linkagegroups] + Length[singletons]}];
        (*Put[{orderlodtype,indeplodmtx,linklodmtx,rfmtx, maxrf,minlodsaving,miniclustersize,knnsnp},"temp2.txt"];*)
        {neighbors, neighborstrength,neighborlod} = getNeighbors[orderlodtype,indeplodmtx,linklodmtx,rfmtx, maxrf,minlodsaving,miniclustersize,knnsnp];
        Switch[orderlodtype,            
            "independence",
            estmap = formRoughMap[snpid,neighbors,neighborstrength,neighborlod,estorder, singletons,eigenval,eigenvec],
            "linkage"|"both",
            estmap = formRoughMap[snpid,neighbors, neighborstrength,neighborlod,estorder, singletons,eigenval,eigenvec,rfmtx,morganrate];
            If[ isprint,
                Print["Genetic map function for initial map construction: scaled fraction = 1-Exp[-"<>ToString[N[Round[morganrate,10^(-2)]]]<>" distance(M)]"];
            ];
        ];
        estmap[[1,1]] = ToString[estmap[[1,1]]]<>"_minLodClustering" <>ToString[minlodclustering] 
        <> "_minLodOrdering" <> If[ Equal @@ minlodordering,
                                    ToString[First[minlodordering]],
                                    toDelimitedString[minlodordering, "|"]
                                ];
        csvExport[outputfile, estmap];
        If[ isprint,
            Print["Done! Finished date =",DateString[], ". \tTime elapsed in total = ", Round[SessionTime[] - starttime,0.1], " Seconds."];
        ];
        outputfile
    ]

calKendallTau[estorder_, snpid_,inputrefmap_] :=
    Module[ {refmap = inputrefmap, order},
        refmap = SplitBy[Join[refmap[[2 ;;, ;; 2]],List /@ Range[Length[refmap] - 1], 2], #[[2]] &];
        refmap = Map[Rule @@ # &, refmap[[All, All, {1, 3}]], {2}];
        order = (snpid[[#]] & /@ estorder) /. Flatten[refmap];
        Round[KendallTau[#, Range[Length[#]]] & /@ order, 0.01]
    ]

getSimilarity[clusterlodtype_, indeplodmtx_, linklodmtx_, 
    rfmtx_, maxrf_, minlod_,minlodmini_,miniclustersize_] :=
    Module[ {lodmtx,aa,ww,f},
        lodmtx = getNeighborLodMtx[clusterlodtype,indeplodmtx,linklodmtx, minlod, minlodmini,miniclustersize];
        lodmtx *= SparseArray[1 - IdentityMatrix[Length[lodmtx]]];
        (*aa = lodmtx+SparseArray[DiagonalMatrix[((Max[#] & /@ lodmtx) /. {0 | 0. -> Max[lodmtx]})]];*)
        aa=lodmtx;        
        If[ clusterlodtype=!="independence",
            f = fractiontosimilarity[rfmtx, maxrf];
            aa = f Sign[aa];
            ww = lodmtx/(Max[lodmtx]+10^(-3.));
            aa += ww Sign[aa] 10^(-6);            
        ];
        aa
    ]
    
findminlodBrent[lodtype_, indeplodmtx_, linklodmtx_,rfmtx_, maxrf_, minlodsaving_, minlod_,miniclustersize_,maxnconn_] :=
    Module[ {func,func0,similarity,len, bool,nconn,nungroup,nungroup0,minlod2,minlodstart,grid,step,fx,lod,flod},
        If[ minlod===Automatic,
            func0 = Function[{x},
                     similarity = getSimilarity[lodtype, indeplodmtx, linklodmtx,rfmtx, maxrf, x,Infinity,miniclustersize];
                     len = Length[#] & /@ adjConnectedComponents[similarity];
                     bool = Positive[len-miniclustersize];
                     len = Pick[len,bool,#]&/@{True,False};
                     {Length[First[len]],Total[Last[len]]}
            ];
            {nconn,nungroup0} = func0[minlodsaving];
            If[maxnconn<nconn,
            	minlod2=minlodsaving,	            
	            func = Function[{x},                     
	                     {nconn,nungroup} = func0[x];
	                     fx = If[ 0 < nconn <= maxnconn,
	                              x^2 nconn/Sqrt[(nungroup-nungroup0+1)],
	                              -x^2
	                          ];
	                     PrintTemporary["{x,#component,max(#component), #ungrouped, #ungrouped(x0), f(x)}=",
	                         {x,nconn,maxnconn,nungroup, nungroup0, fx}];
	                     fx                     
	                 ];
	            step = 1.0;
	            lod = N[minlodsaving];
	            flod = func[lod];
	            grid = {{lod, flod}};
	            While[True,
	              lod += step;
	              flod = func[lod];
	              grid = Join[grid, {{lod, flod}}];
	              If[ flod < 0,
	                  Break[]
	              ];
	              ];
	            minlodstart = MaximalBy[grid, Last][[1, 1]];
	            minlod2 = brentLocalMax[func,minlodstart,Max[0,minlodstart-step],minlodstart+step, AccuracyGoal ->1,PrecisionGoal -> 2];
	            minlod2 = First[minlod2]
            ],
	        minlod2 = minlod
	    ];
	    N[Round[minlod2,10^(-3)]]
    ]
         
        
removewronglinkednode[linkagegroups_, singletons_, strongneighbors_] :=
    Module[ {groupsize,temp,k,pos},
        groupsize = Length[#] & /@ linkagegroups;
        temp = Table[
            temp = strongneighbors[[linkagegroups[[k]]]];
            Flatten[Position[temp, _?(! MemberQ[linkagegroups[[k]], #] &), {1},Heads -> False]], {k, Length[linkagegroups]}];
        pos = MapThread[Complement[Range[#1], #2] &, {groupsize, temp}];
        {Table[linkagegroups[[k, pos[[k]]]], {k, Length[linkagegroups]}],
         Flatten[{singletons, MapThread[#1[[#2]] &, {linkagegroups, temp}]}]}
    ]         
    
getNeighborLodMtx[orderlodtype_, indeplodmtx_,linklodmtx_, minlod_, minlodmini_,miniclustersize_] :=
    Module[ {neighbors},
        Switch[orderlodtype,
            "independence",
            neighbors = SparseArray[indeplodmtx toSparseIndicator[indeplodmtx, minlod, minlodmini,miniclustersize]],
            "linkage",
            neighbors = SparseArray[linklodmtx toSparseIndicator[linklodmtx, minlod, minlodmini,miniclustersize]],
            "both",
            neighbors = SparseArray[linklodmtx toSparseIndicator[linklodmtx, minlod, minlodmini,miniclustersize]*toSparseIndicator[indeplodmtx, minlod,minlodmini, miniclustersize]]
         ];
        neighbors
    ]      
             
    
getNeighbors[orderlodtype_, indeplodmtx_, linklodmtx_, rfmtx_, maxrf_, minlod_, miniclustersize_, knnsnp_] :=
    Module[ {simmtx,lodmtx,i,neighbors,neighbornode, neighborsim, neighborlod,minlodmini=0},
        simmtx = getSimilarity[orderlodtype, indeplodmtx, linklodmtx, rfmtx, maxrf,minlod, minlodmini, miniclustersize];
        Do[simmtx[[i, i]] = Infinity, {i, Length[simmtx]}];        
        neighbors = Most[SortBy[Most[ArrayRules[#]], Last]] & /@ simmtx;
        neighbors = Reverse[#] & /@ neighbors;
        neighbors = MapThread[Take[#1, UpTo[#2]] &, {neighbors, knnsnp}];
        neighbornode = neighbors[[All, All, 1, 1]];
        neighborsim = Normal[MapThread[#2[[#1]] &, {neighbornode, simmtx}]];
        lodmtx = getNeighborLodMtx[orderlodtype, indeplodmtx, linklodmtx, minlod, minlodmini, miniclustersize];
        neighborlod = Normal[MapThread[#2[[#1]] &, {neighbornode, lodmtx}]];
        neighbornode = toDelimitedString[neighbornode] /. {"" -> "NA"};
        neighborlod = toDelimitedString[Round[neighborlod, 1/10] /. {x_Rational :> N[x]}] /. {"" -> "NA"};
        neighborsim = toDelimitedString[Round[neighborsim, 1/100] /. {x_Rational :> N[x]}] /. {"" ->"NA"};
        {neighbornode, neighborsim, neighborlod}
    ]    
       
getStrongestNeighbors[clusterlodtype_,linklodmtx_, indeplodmtx_,minlod_,miniclustersize_] :=
    Module[ {neighbors,minlodmini = minlod},
        neighbors = getNeighborLodMtx[clusterlodtype,indeplodmtx,linklodmtx, minlod, minlodmini,miniclustersize];
        neighbors = Most[SortBy[Most[ArrayRules[#]], Last]] & /@ neighbors;
        neighbors = Reverse[#] & /@ neighbors;
        neighbors = Take[#, UpTo[1]] & /@ neighbors;
        neighbors = Replace[neighbors[[All, All, 1, 1]], {{} -> None, {x_} :> x}, {1}];
        neighbors
    ]    
                               
(************************************************************************************************)

toSymmetricNeighborhood[inputneighborhood_] :=
    Module[ {neighborhood = inputneighborhood, rule, revrule,lod,lod2,temp,i},
        rule = neighborhood[[All, 1]];
        rule = Thread[rule -> Range[Length[rule]]];
        neighborhood[[All, ;; 2]] = neighborhood[[All, ;; 2]] /. rule;
        lod2 = lod = Flatten[Thread[Thread[#[[;; 2]]] -> #[[3]]] & /@ neighborhood, 1];
        lod2[[All, 1]] = Reverse[#] & /@ lod2[[All, 1]];
        lod = Union[lod, lod2];
        lod = SparseArray[lod, {Length[neighborhood], Length[neighborhood]}];
        (*SymmetricMatrixQ[lod]*)
        lod = Table[
           temp = SortBy[Most[ArrayRules[lod[[i]]]], -#[[2]] &];
           {i, temp[[All, 1, 1]], temp[[All, 2]]}, {i, Length[lod]}];
        revrule = Reverse[#] & /@ rule;
        lod[[All, ;; 2]] = lod[[All, ;; 2]] /. revrule;
        lod
    ]

(*roughtmap has columns "MarkerID","LinkageGroupNo","Position(cM)","InterMarkerFraction",
                        "InputMarkerNo","NearestNeighbors","neighborstrengths"*)   
decomposeRoughMap[roughmap_, isrevdis_:True] :=
    Module[ {linkagemap, ls, initorder, initdeltd, initneighborhood,i,pattern,temp},
        linkagemap = DeleteCases[roughmap, _?(MatchQ[#[[2]], "ungrouped"] &)];
        ls = SplitBy[linkagemap[[2 ;;]], #[[2]] &];
        initdeltd = Table[Differences[ls[[i, All, 3]]], {i, Length[ls]}]/100.;
        If[ isrevdis,
            (*to be consistent with {lowbound,upbound}={-16,0} for Log[deltd]*)
            initdeltd = Table[
                  Replace[initdeltd[[i]], {_?(# < 10^(-4.)&) :> 10^(-4.),_?(# > 0.1 &) :> 0.1}, {1}], {i, Length[initdeltd]}];
        ];
        If[ Dimensions[roughmap][[2]] < 5,
            initorder = Missing[],
            initorder = ls[[All, All, 5]];
            initorder = Table[Thread[initorder[[i]] -> Range[Length[initorder[[i]]]]], {i,Length[initorder]}];
        ];
        If[ Dimensions[roughmap][[2]] < 6,
            initneighborhood = Missing[],
            (*initneighborhood = ls[[All, All, {5, 6, 7}]];
            initneighborhood[[All, All, 2 ;; 3]] = Map[ToString, initneighborhood[[All, All, 2 ;; 3]], {3}];
            initneighborhood[[All, All, 2 ;; 3]] = Map[ToExpression[StringSplit[#, "|"]] &,initneighborhood[[All, All, 2 ;; 3]], {2}];        
            initneighborhood[[All, All, 3]] = Map[Exp[# - Min[#]] &, N[initneighborhood[[All, All, 3]]], {2}];*)
            (*initneighborhood[[All, All, 3]] = N[initneighborhood[[All, All, 3]]^2];*)
            (*Set weights=1 instead of Neighborstrength; all nearest neighbors are denoted by positive interger indices*)
            initneighborhood = ls[[All, All, {5, 6, 6}]];
            initneighborhood[[All, All, 2 ;; 3]] = Map[ToString, initneighborhood[[All, All, 2 ;; 3]], {3}];
            initneighborhood[[All, All, 2 ;; 3]] = Map[ToExpression[StringSplit[#, "|"]] &,initneighborhood[[All, All, 2 ;; 3]], {2}];
            initneighborhood[[All, All, 3]] = Sign[initneighborhood[[All, All, 3]]];
            Do[(*delete neighbors that are not in that group*)
                pattern = Complement[Union[Flatten[initneighborhood[[i, All, 2]]]], 
                initneighborhood[[i, All, 1]]];
                pattern = Alternatives @@ Thread[{pattern, _}];
                temp = Transpose[#] & /@ initneighborhood[[i, All, {2, 3}]];
                temp = DeleteCases[temp, pattern, {2}];
                initneighborhood[[i, All, {2, 3}]] = If[ # === {},
                                                         {},
                                                         Transpose[#]
                                                     ] & /@ temp, {i,Length[initneighborhood]}];
            initneighborhood = toSymmetricNeighborhood[#] & /@ initneighborhood;
            initneighborhood = Map[#[[1]] -> (#[[3]] -> #[[2]]) &, initneighborhood, {2}];
            initneighborhood = Association[#] & /@ initneighborhood;
        ];
        {initorder, initdeltd, initneighborhood}
    ]
        
expectedInterDistance[model_,groupstartProb_, grouptranProb_, groupdataprob_, samplemapR_,nfgl_,ischX_,offspringgender_] :=
    Module[ {res, trancount, ngamete,posA, posX,logl, pos,
      diposteriorprob, avgtran, fraction, deltd, ind},
        (*analyze linkage group by linkage group*)
        If[ ischX,
            {posA,posX} = {{},{1}},
            {posA,posX} = {{1},{}}
        ];
        {trancount, ngamete} = getgametetran[model,nfgl, posA, posX, offspringgender];
        trancount = trancount[[All, 1]];
        ngamete = ngamete[[1]];
        res = Table[
           {logl, diposteriorprob} = CtDiPosteriorDecoding[groupstartProb[[ind]], grouptranProb[[All,ind]],groupdataprob[[All, ind]]];
           diposteriorprob = Map[Flatten, diposteriorprob];
           avgtran = diposteriorprob.trancount[[ind]];
           {logl, avgtran}, {ind, Length[trancount]}];
        {logl, avgtran} = Transpose[res];
        logl = Total[logl];
        fraction = (Total[avgtran])/(ngamete);
        deltd = (-Log[1 - nfgl/(nfgl - 1) fraction]) (nfgl -1)/(nfgl samplemapR);
        pos = Flatten[Position[fraction-(nfgl -1)/nfgl,_?NonNegative]];
        deltd[[pos]] = 10;
        {logl, deltd}
    ]    
  

togroupstarttranprob[samplelabel_, continuedmarkovprocess_, deltd_] :=
    Module[ {groupstartprob, grouptranprob, discretemarkovprocess},
        discretemarkovprocess =  toDiscreteMarkovProcess[continuedmarkovprocess, {deltd}];
        {groupstartprob, grouptranprob} =  toStartTranProb[samplelabel, discretemarkovprocess];
        groupstartprob = groupstartprob[[All, 1]];
        grouptranprob = Transpose[grouptranprob[[All, 1]]];
        {groupstartprob, grouptranprob}
    ]
    
(*input groupstartProb: dim {nind,nstate} for a given linkage group*)
(*input grouptranProb: dim {nsnp,nind,nstate} for a given linkage group*)
(*input groupdataprob: dim {nsnp,nind,nstate} for a given linkage group*)
(*fowardProb[[t,ind]] =  Pr(x_t|y_{1...t}); dim={nsnp,nind,nstate}*)
(*forwardScale[[t, ind]] = Pr(y_t|y_{1...t-1}); dim ={nsinp,nind}*)
(*logbackwardProb[[t=T,ind]] = {0,...0}*)
(*logbackwardProb[[t,ind]] =  Log[Pr(y_{t+1...T}|x_t)]; dim={nsnp,nind,nstate}*)
groupForward[groupstartProb_, grouptranProb_, groupdataprob_] :=
    Module[ { res, forwardProb, forwardScale, ind},
        res = Table[CtForward[groupstartProb[[ind]], grouptranProb[[All,ind]], groupdataprob[[All, ind]]], {ind, Length[groupstartProb]}];
        {forwardProb, forwardScale} = Transpose[#] & /@ Transpose[res];
        (*resturn res with dim={{nsnp,nind,nstate},{nsnp,nind}*)
        {forwardProb, forwardScale}
    ]

groupBackward[grouptranProb_, groupdataprob_,grouplogbackinit_:Automatic] :=
    Module[ {nind,nstate,loginit,ind},
        {nind,nstate} = Dimensions[First[grouptranProb]][[;;2]];
        loginit = If[ grouplogbackinit===Automatic,
                      ConstantArray[0,{nind,nstate}],
                      grouplogbackinit
                  ];
        (*resturn res with dim={nsnp,nind,nstate}*)
        Transpose[Table[CtLogBackward[grouptranProb[[All,ind]], groupdataprob[[All, ind]],loginit[[ind]]], {ind, nind}]]
    ] 
    
groupForwardBackward[groupstartProb_, grouptranProb_, groupdataprob_] :=
    Module[ {forwardProb, forwardScale,forwardlogl,logbackwardProb},
        {forwardProb, forwardScale} = groupForward[groupstartProb, grouptranProb,groupdataprob];
        forwardlogl = Accumulate[Total[Log[forwardScale], {2}]];
        logbackwardProb = groupBackward[grouptranProb, groupdataprob];
        {forwardProb, forwardScale,forwardlogl,logbackwardProb}
    ]    
        
(*fwprob dim: {nind,nstate}*)
(*logbwprob dim: [nind,nstate} log scale backward probability without scaling*)
(*return a list of logl for each individual*)
calgroupcondlogl[fwprob_, logbwprob_] :=
    Module[ {ls},
        ls = Max[#] & /@ logbwprob;
        Log[MapThread[#1.#2 &, {fwprob, Exp[logbwprob - ls]}]] + ls
    ]        
    
updateforwardbackward[t_, snporder_, grouptranprob_, dataprobset_, 
  inputforindicator_, inputforwardProb_, inputforwardScale_, inputforwardlogl_, inputbackindicator_, inputlogbackwardProb_] :=
    Module[ {forindicator, forwardProb, forwardScale, forwardlogl, 
      backindicator, logbackwardProb, tchange, tmin, tmax, segtranprob, segdataprob, segstartprob},
        {forindicator, forwardProb, forwardScale, forwardlogl, backindicator, logbackwardProb} = 
            {inputforindicator,inputforwardProb, inputforwardScale, inputforwardlogl,inputbackindicator, inputlogbackwardProb};
        tchange = Position[forindicator, 0, {1}, 1, Heads -> False];
        If[ tchange =!= {} && t >= tchange[[1,1]],
            {tmin, tmax} = {tchange[[1,1]], t};
            If[ forindicator[[tmin ;; tmax]] == Table[0, {tmax - tmin + 1}],
                segtranprob = grouptranprob[[tmin ;; tmax - 1]];
                segdataprob = dataprobset[[snporder[[tmin ;; tmax, 1]]]];
                segstartprob = MapThread[#1.#2 &, {forwardProb[[tmin - 1]],grouptranprob[[tmin - 1]]}];
                {forwardProb[[tmin ;; tmax]], forwardScale[[tmin ;; tmax]]} = groupForward[segstartprob, segtranprob, segdataprob];
                forwardlogl[[tmin ;; tmax]] = forwardlogl[[tmin - 1]] + Accumulate[Total[Log[forwardScale[[tmin ;; tmax]]], {2}]];
            ];
            forindicator[[tmin ;; tmax]] = 1;
        ];
        tchange = Position[backindicator, 1, {1}, 1, Heads -> False];
        If[ t<tchange[[1,1]],
            {tmin, tmax} = {t, tchange[[1,1]]};
            segtranprob = grouptranprob[[tmin ;; tmax - 1]];
            segdataprob = dataprobset[[snporder[[tmin ;; tmax, 1]]]];
            logbackwardProb[[tmin ;; tmax]] = groupBackward[segtranprob, segdataprob, logbackwardProb[[tmax]]];
            backindicator[[tmin ;; tmax]] = 1
        ];
        {forindicator, forwardProb, forwardScale, forwardlogl,backindicator, logbackwardProb}
    ]
  
segmentRefineLocal[inputsnporder_, inputdeltd_,inputforwardProb_, inputforwardScale_, inputforwardlogl_, 
    inputlogbackwardProb_, groupstartprob_, inputgrouptranprob_, dataprobset_, snpneighbor_,windowsize_,temperature_,inputaction_] :=
    Module[ {snporder = inputsnporder, deltd = inputdeltd,forwardProb = inputforwardProb,forwardScale = inputforwardScale, forwardlogl = inputforwardlogl,
        logbackwardProb = inputlogbackwardProb,grouptranprob = inputgrouptranprob,action,forindicator,backindicator,nsnp,seg,accept,realwindowsize,t,tmin,tmax,indice,pos,
        isneighbor,isrightneighbor,isleftneighbor,isinnerneighbor,logl,logl2, leftlogl,newlogl,segstartprob,segtranprob, segdataprob, newsegforwardprob, newsegforwardscale, cond,fun},
        nsnp = Length[snporder];
        realwindowsize = accept = Table[0, {nsnp}];
        forindicator = backindicator = Table[1, {nsnp}];
        logl = Last[forwardlogl];
        action = ToLowerCase[inputaction];
        fun = Switch[action,
            "reverse"|"reverseneighbor"|"reverseinnerneighbor"|"reverseleftneighbor"|"reverserightneighbor", Reverse[#]&,
            "rotateleft"|"rotateleftneighbor",RotateLeft[#,1]&,
            "rotateright"|"rotaterightneighbor",RotateRight[#,1]&,
            _, 
            Print["segmentRefine: unknown segment refine operator ",inputaction];
            Abort[];
         ];
        isneighbor = MatchQ[action, "reverseneighbor"|"reverseinnerneighbor"|"reverserightneighbor" | "rotaterightneighbor"|"reverseleftneighbor" | "rotateleftneighbor"];
        isrightneighbor = MatchQ[action, "reverserightneighbor" | "rotaterightneighbor"];
        isleftneighbor = MatchQ[action,"reverseleftneighbor" | "rotateleftneighbor"];
        isinnerneighbor = MatchQ[action, "reverseinnerneighbor"];
        t = 1;
        While[True,   
         tmin = t;
         If[ tmin>=nsnp,
             Break[]
         ];
         If[ isneighbor,
             If[ nsnp-t<=2,
                 tmax = nsnp,
                 indice = Lookup[snpneighbor, snporder[[t, 1]]];
                 indice[[2]] = indice[[2]] /. snporder;
                 pos = Flatten[Position[indice[[2]], _?(#>t&)]];
                 (*pos =All;*)
                 If[ pos === {},
                     t++;
                     Continue[],
                     tmax = RandomChoice[indice[[All, pos]]];
                     (*{tmin,tmax}=Sort[{tmin,tmax}];*)
                     If[ isinnerneighbor||(isleftneighbor&&RandomReal[]<0.5),
                         tmax -= 1
                     ];
                 ];
             ];
             If[ isinnerneighbor||(isrightneighbor&&RandomReal[]<0.5),
                 tmin += 1
             ],
             tmax = Min[tmin + windowsize - 1,nsnp];
         ];
         If[ (tmin >= tmax),
             t++;
             Continue[]
         ];
         (*Print["{t,tmin,tmax}=",{t,tmin,tmax}];*)
         {forindicator, forwardProb, forwardScale, forwardlogl, backindicator,logbackwardProb} = updateforwardbackward[tmax, snporder, 
             grouptranprob, dataprobset,forindicator, forwardProb, forwardScale, forwardlogl,backindicator, logbackwardProb];
         logl2 = Total[calgroupcondlogl[forwardProb[[tmax]], logbackwardProb[[tmax]]]] +forwardlogl[[tmax]];
         If[ (logl-logl2)>10^(-5.),
             Print["segmentRefineLocal: inconsistent log likelihoods: ", {logl, logl2}];
             Abort[]
         ];
         seg = Range[tmin, tmax];
         If[ tmin == 1,
             segstartprob = groupstartprob;
             leftlogl = 0,
             segstartprob = MapThread[#1.#2 &, {forwardProb[[tmin - 1]], grouptranprob[[tmin - 1]]}];
             leftlogl = forwardlogl[[tmin - 1]]
         ];
         segtranprob = fun[grouptranprob[[Most[seg]]]];
         segdataprob = dataprobset[[snporder[[fun[seg],1]]]];
         {newsegforwardprob, newsegforwardscale} = groupForward[segstartprob, segtranprob, segdataprob];
         newlogl = Total[calgroupcondlogl[newsegforwardprob[[-1]],logbackwardProb[[tmax]]]] + Total[Log[Flatten[newsegforwardscale]]]+leftlogl;
         If[ temperature < 10^(-5.),
             cond = newlogl > logl,
             cond = RandomReal[] < Min[1, Exp[(newlogl - logl)/temperature]]
         ];
         If[ cond,
             accept[[t]] = True;
             backindicator[[;; tmax - 1]] = 0;
             logbackwardProb[[;; tmax - 1]] = Missing[];
             snporder[[seg, 1]] = snporder[[fun[seg], 1]];
             deltd[[Most[seg]]] = fun[deltd[[Most[seg]]]];
             grouptranprob[[Most[seg]]] = fun[grouptranprob[[Most[seg]]]];
             logl = newlogl;
             forwardProb[[tmin;;tmax]] = newsegforwardprob;
             forwardScale[[tmin;;tmax]] = newsegforwardscale;
             forwardlogl[[tmin;;tmax]] = leftlogl + Accumulate[Total[Log[newsegforwardscale], {2}]];
             forindicator[[tmin;;tmax]] = 1;
             If[ tmax < nsnp,
                 forindicator[[tmax + 1 ;;]] = 0;
                 forwardProb[[tmax + 1 ;;]] = Missing[];
                 forwardScale[[tmax + 1 ;;]] = Missing[];
                 forwardlogl[[tmax + 1 ;;]] = Missing[];
             ],
             accept[[t]] = False;
         ];
         realwindowsize[[t]] = tmax-tmin+1;
         (*Print["{t,tmin,tmax,cond,accept[[t]],logl,newlogl,leftlogl}=",{t,tmin,tmax,cond,accept[[t]],logl,newlogl,leftlogl}];*)
         t+=RandomInteger[{1, Max[1,Round[(tmax - t)/5]]}];
        ];
        accept = DeleteCases[accept,0];
        realwindowsize = DeleteCases[realwindowsize,0];
        If[ (logl-Last[forwardlogl])>10^(-5.),
            Print["segmentRefine: wrong logl=", logl,", or Last[forwardlogl]=",Last[forwardlogl],"!"];
            Abort[]
        ];
        If[ Union[forindicator]=!={1},
            Print["segmentRefine: wong forward indicator = ",forindicator,"!"];
            Print["t,tmax=",{t,tmax}];
        (*Abort[]*)
        ];
        {snporder, deltd,forwardProb, forwardScale, forwardlogl, grouptranprob,realwindowsize,accept, logl}
    ] 
        
updatemarkerdistanceEM[model_,snps_, inputdeltd_, samplelabel_, continuedmarkovprocess_, dataprobset_, 
    samplemapR_, ischX_, offspringgender_] :=
    Module[ {deltd = inputdeltd, groupstartprob, grouptranprob,groupdataprob, logl,nfgl},
     (*groupstartprob dim={nind,nstate}, grouptranprob dim = {nsnp,nind,
     nstate,nstate}, groupdataprob dim ={nsnp,nind,nstate}*)
        nfgl = Mean[Length[#] & /@ samplelabel[[2 ;;, 4]]];
        If[ ! IntegerQ[nfgl],
            Print["updatemarkerdistance: unexpected nfgl!"];
            Abort[]
        ];
        groupdataprob = dataprobset[[snps]];
        {groupstartprob, grouptranprob} = togroupstarttranprob[samplelabel, continuedmarkovprocess, deltd];
        {logl, deltd} = expectedInterDistance[model,groupstartprob, grouptranprob, groupdataprob,
           samplemapR, nfgl, ischX, offspringgender];
        {logl, deltd}
    ]

calcurrentlogl[lnd_, samplelabel_, continuedmarkovprocess_,
  tfwprob_, tfwlogl_,tnextdataprob_, tnextlogbwprob_] :=
    Module[ {tdiscretemarkov, logl, ttranprob, tnextfwprob, tnextfwlogl,temp},
        tdiscretemarkov = toDiscreteMarkovProcess[continuedmarkovprocess, {{Exp[lnd]}}];
        ttranprob = Last[toStartTranProb[samplelabel, tdiscretemarkov]];
        ttranprob = ttranprob[[All, 1, 1]];
        (*Total[Transpose[tfwprob ttranprob]]*)
        tnextfwprob = MapThread[#1.#2 &, {tfwprob, ttranprob}] tnextdataprob;
        temp = Total[Transpose[tnextfwprob]];
        tnextfwprob /= temp;
        tnextfwlogl = tfwlogl+Total[Log[temp]];
        logl = Total[calgroupcondlogl[tnextfwprob, tnextlogbwprob]] + tnextfwlogl;
        {logl, tnextfwprob, tnextfwlogl}
    ]

updatemarkerdistanceMC[snps_, snpdeltd_, samplelabel_, continuedmarkovprocess_, dataprobset_,priorchrlength_,temperature_] :=
    Module[ {deltd,groupstartprob, grouptranprob, forwardProb, t,lowbound,upbound,
      forwardScale, forwardlogl, logbackwardProb, loglhistory, tfwprob,nproposal = 3,propstepsize = Log[5.],
      tfwlogl, tnextdataprob, tnextlogbwprob,logl,now,nowres,prop,propres,proplogl,cond,count,accepthistory,
      logprior,restlength},
        (*priorchrlength in unit of Morgan*)
        (*logprior = Function[{lnd,rest},-Log[priorchrlength]+lnd-(Exp[lnd]+rest)/priorchrlength];*)
        (*remove dependence on rest, so that we give a prior for each inter-marker distance rather than total length*)
        logprior = Function[{lnd,rest},-Log[priorchrlength]+lnd-(Exp[lnd])/priorchrlength];
        deltd = snpdeltd;
        {lowbound,upbound} = {-16,0};
        {groupstartprob, grouptranprob} = togroupstarttranprob[samplelabel, continuedmarkovprocess, deltd];
        {forwardProb, forwardScale, forwardlogl, logbackwardProb} = 
         groupForwardBackward[groupstartprob, grouptranprob, dataprobset[[snps]]];
        loglhistory = Table[0, {Length[forwardlogl]}];
        loglhistory[[1]] = logl = Last[forwardlogl];
        accepthistory = Table[0,{Length[grouptranprob]}];
        forwardlogl[[2;;]] = Missing[];
        Do[ 
            restlength = Total[deltd]-deltd[[t]];
            tfwprob = forwardProb[[t]];
            tfwlogl = forwardlogl[[t]];
            tnextdataprob = dataprobset[[snps[[t + 1]]]];
            tnextlogbwprob = logbackwardProb[[t + 1]];
            now = Log[deltd[[t]]];
            nowres = calcurrentlogl[now, samplelabel, continuedmarkovprocess,
                          tfwprob, tfwlogl,tnextdataprob, tnextlogbwprob];
            If[ Abs[loglhistory[[t]]-First[nowres]]>10^(-5.),
                Print["updatemarkerdistanceMC: inconsistent log likelihoods: ", {t,loglhistory[[t]], First[nowres]}];
                Abort[]
            ];
            logl = First[nowres]+logprior[now,restlength];
            count = 0;
            Do[
                prop = RandomReal[NormalDistribution[now,propstepsize]];
                (*prop = now+RandomReal[UniformDistribution[{-propstepsize,propstepsize}]];*)
                If[ lowbound<prop<upbound,
                    propres = calcurrentlogl[prop, samplelabel, continuedmarkovprocess,
                          tfwprob, tfwlogl,tnextdataprob, tnextlogbwprob];
                    proplogl = First[propres]+logprior[prop,restlength];
                    If[ temperature < 10^(-5.),
                        cond = proplogl > logl,
                        cond = RandomReal[] < Min[1, Exp[(proplogl - logl)/temperature]]
                    ];
                    If[ cond,
                        {now,logl} = {prop,proplogl};
                        nowres = propres;
                        count++
                    ];
                ],{nproposal}];
            accepthistory[[t]] = count/nproposal;
            deltd[[t]] = Exp[now];
            {forwardProb[[t + 1]],forwardlogl[[t+1]]} = Rest[nowres];
            loglhistory[[t + 1]] = logl-logprior[now,restlength];
            0, {t, Length[forwardProb]-1}];
        If[ Abs[Last[loglhistory]-Last[forwardlogl]]>10^(-5.),
            Print["updatemarkerdistanceMC: inconsistent log likelihoods: ", {Last[loglhistory], Last[forwardlogl]}];
            Abort[]
        ];
        {loglhistory[[{1,-1}]],deltd,Round[Mean[accepthistory],0.01]}
    ]
    
updatemarkerdistanceBrent[snps_, snpdeltd_, samplelabel_, continuedmarkovprocess_, dataprobset_,priorchrlength_] :=
    Module[ {lowbound, upbound, accuracygoal, precisiongoal, itmax, deltd,
       groupstartprob, grouptranprob, forwardProb, t,
      forwardScale, forwardlogl, logbackwardProb, loglhistory, tfwprob,tfwlogl,
      tnextdataprob, tnextlogbwprob, loglfunc, dmax, loglrmax, his,logprior,restlength},
        (*priorchrlength in unit of Morgan*)
        (*logprior = Function[{lnd,rest},-Log[priorchrlength]-(Exp[lnd]+rest)/priorchrlength];*)
        (*remove dependence on rest, so that we give a prior for each inter-marker distance rather than total length*)
        logprior = Function[{lnd,rest},-Log[priorchrlength]-(Exp[lnd])/priorchrlength];
        {accuracygoal, precisiongoal, itmax} = {3, 3, 100};
        {lowbound,upbound} = {-16,0};
        deltd = snpdeltd;
        {groupstartprob, grouptranprob} = togroupstarttranprob[samplelabel, continuedmarkovprocess, deltd];
        {forwardProb, forwardScale, forwardlogl, logbackwardProb} = 
         groupForwardBackward[groupstartprob, grouptranprob, dataprobset[[snps]]];
        loglhistory = Table[0, {Length[forwardlogl]}];
        loglhistory[[1]] = Last[forwardlogl];
        forwardlogl[[2;;]] = Missing[];
        Do[
         restlength = Total[deltd]-deltd[[t]];
         tfwprob = forwardProb[[t]];
         tfwlogl = forwardlogl[[t]];
         tnextdataprob = dataprobset[[snps[[t + 1]]]];
         tnextlogbwprob = logbackwardProb[[t + 1]];
         loglfunc = Function[{x},First[calcurrentlogl[x, samplelabel, continuedmarkovprocess,
            tfwprob, tfwlogl,tnextdataprob, tnextlogbwprob]]+logprior[x,restlength]];
         {dmax, loglrmax, his} = brentLocalMax[loglfunc,Log[deltd[[t]]],lowbound,upbound, AccuracyGoal -> accuracygoal, 
           PrecisionGoal -> precisiongoal, MaxIterations -> itmax];
         deltd[[t]] = Exp[dmax];
         {loglhistory[[t+1]],forwardProb[[t + 1]],  forwardlogl[[t+1]]} = 
          calcurrentlogl[dmax, samplelabel, continuedmarkovprocess, tfwprob, tfwlogl, tnextdataprob, tnextlogbwprob];
         If[ loglhistory[[t+1]]!=loglrmax-logprior[dmax,restlength],
             Print["updatemarkerdistanceBrent: inconsistent logl!"];
         ];
         0, {t, Length[grouptranprob]}];
        {loglhistory[[{1,-1}]],deltd}
    ]


updatedistancescaleMC[snps_, inputsnpdeltd_, samplelabel_, continuedmarkovprocess_, dataprobset_, priorchrlength_,temperature_] :=
    Module[ {loglfunc,groupdataprob, groupstartprob, grouptranprob, forwardProb, 
      forwardScale, logl, propstepsize = Log[2.],logprior,snpdeltd = inputsnpdeltd,
      nproposal = 3, oldlogl, nowlogl, count, now, prop, proplogl, cond},
        groupdataprob = dataprobset[[snps]];
        (*logprior = Function[{x},- Log[priorchrlength/Total[snpdeltd]] +x- (Exp[x] Total[snpdeltd]/priorchrlength)];*)
        logprior = Function[{x},- Log[priorchrlength/Mean[snpdeltd]] +x- (Exp[x] Mean[snpdeltd]/priorchrlength)];
        loglfunc = Function[{x},
          {groupstartprob, grouptranprob} = togroupstarttranprob[samplelabel, continuedmarkovprocess,Exp[x] snpdeltd];
          {forwardProb, forwardScale} = groupForward[groupstartprob, grouptranprob, groupdataprob];
          logl = Total[Log[Flatten[forwardScale]]];
          logl
          ];
        now = 0;
        oldlogl = nowlogl = loglfunc[now];
        count = 0;
        Do[
         prop = now+RandomReal[UniformDistribution[{-propstepsize,propstepsize}]];
         proplogl = loglfunc[prop];
         If[ temperature < 10^(-5.),
             cond = proplogl+logprior[prop] > nowlogl+logprior[now],
             cond = RandomReal[] < Min[1, Exp[(proplogl+logprior[prop]-nowlogl-logprior[now])/temperature]]
         ];
         If[ cond,
             {now, nowlogl} = {prop, proplogl};
             count++
         ];
         0, {nproposal}];
        snpdeltd*=Exp[now];
        snpdeltd = Replace[snpdeltd, {_?(# < Exp[-16.]&) :> Exp[-16.],_?(# > 1 &) :> 1}, {1}];
        If[ snpdeltd=!=inputsnpdeltd,
            nowlogl = loglfunc[0];
        ];
        {{oldlogl, nowlogl}, snpdeltd, Round[count/nproposal,0.01]}
    ]

updatedistancescaleBrent[snps_, inputsnpdeltd_, samplelabel_, continuedmarkovprocess_, dataprobset_, priorchrlength_] :=
    Module[ {logprior, loglfunc, groupdataprob, groupstartprob, snpdeltd = inputsnpdeltd,
      grouptranprob, forwardProb, forwardScale, logl, accuracygoal, 
      precisiongoal, itmax, lowbound, upbound, dmax, loglmax, his, 
      oldlogl, nowlogl},
        groupdataprob = dataprobset[[snps]];        
        (*logprior = Function[{x},- Log[priorchrlength/Total[snpdeltd]] +x- (Exp[x] Total[snpdeltd]/priorchrlength)];*)
        logprior = Function[{x},- Log[priorchrlength/Mean[snpdeltd]] +x- (Exp[x] Mean[snpdeltd]/priorchrlength)];
        loglfunc = Function[{x},
          {groupstartprob, grouptranprob} = togroupstarttranprob[samplelabel, continuedmarkovprocess,Exp[x] snpdeltd];
          {forwardProb, forwardScale} = groupForward[groupstartprob, grouptranprob, groupdataprob];
          logl = Total[Log[Flatten[forwardScale]]];
          logl
          ];
        {accuracygoal, precisiongoal, itmax} = {2, 2, 100};
        {lowbound, upbound} = {-1, 1} Log[5.];
        {dmax, loglmax, his} = brentLocalMax[(loglfunc[#] + logprior[#] &), 0,lowbound, upbound, 
          AccuracyGoal -> accuracygoal, PrecisionGoal -> precisiongoal,MaxIterations -> itmax];
        oldlogl = loglfunc[0];
        snpdeltd *= Exp[dmax];
        snpdeltd = Replace[snpdeltd, {_?(# < Exp[-16.] &) :> Exp[-16.], _?(# > 1 &) :>1}, {1}];
        nowlogl = If[ snpdeltd=!=inputsnpdeltd,
                      loglfunc[0],
                      loglmax-logprior[dmax]
                  ];
        {{oldlogl, nowlogl}, snpdeltd}
    ]
          
updatemarkerorder[inputsnporder_, inputdeltd_, actionls_,samplelabel_, 
  continuedmarkovprocess_, dataprobset_, snpneighbor_,meanwindowsize_, temperature_] :=
    Module[ {acceptls, loglls, snporder = inputsnporder, 
     deltd = inputdeltd, forwardProb, forwardScale, forwardlogl,i, 
     logbackwardProb, windowsizels, realwindowsizels,groupstartprob, grouptranprob},
        acceptls = loglls = Table[0, {Length[actionls]}];
        windowsizels = RandomInteger[TruncatedDistribution[{1, Infinity}, PoissonDistribution[3 meanwindowsize/4]],1];
        windowsizels = Join[windowsizels,RandomInteger[TruncatedDistribution[{2, Infinity}, PoissonDistribution[meanwindowsize]],Length[actionls]-1]];
        (*windowsizels = RandomInteger[TruncatedDistribution[{1, Infinity}, PoissonDistribution[meanwindowsize]],Length[actionls]];*)
        {groupstartprob, grouptranprob} = togroupstarttranprob[samplelabel, continuedmarkovprocess, deltd];
        {forwardProb, forwardScale, forwardlogl, logbackwardProb} = groupForwardBackward[groupstartprob, grouptranprob, dataprobset[[snporder[[All,1]]]]];
        realwindowsizels = Table[0,{ Length[actionls]}];
        Do[
         (*temp = PrintTemporary["Improving ordering by ", actionls[[i]],"..."];*)
         {snporder, deltd, forwardProb, forwardScale, forwardlogl, grouptranprob, realwindowsizels[[i]],acceptls[[i]], loglls[[i]]} = 
          segmentRefineLocal[snporder, deltd, forwardProb, forwardScale, forwardlogl, 
              logbackwardProb,groupstartprob, grouptranprob, dataprobset, snpneighbor,windowsizels[[i]], temperature,actionls[[i]]];
         logbackwardProb = groupBackward[grouptranprob, dataprobset[[snporder[[All,1]]]]];
         0, {i, Length[actionls]}];
        {snporder, deltd, realwindowsizels,acceptls, loglls}
    ]
                 
updatePhasing[magicSNP_, model_, popDesign_, epsF_, eps_, ischrX_,snps_, snpdeltd_, minphredscore_,foundercallthreshold_,
   isfounderinbred_, isfounderdepth_, isoffspringdepth_, boolparent_,booloff_,imputingbound_,errorgenobound_] :=
    Module[ {submagicsnp,dataprobset,starttime = SessionTime[],temp,isprint = False,isextrareverse = True,
        maxfoundererror = 0,ibdprob,model2}, 
        (*all chromosome IDs were set as NA*)
        submagicsnp = getsubMagicSNP[magicSNP, All, snps];
        submagicsnp[[4,2;;]] = Join[{0},Accumulate[snpdeltd]];
        submagicsnp[[3, 2 ;;]] = If[ ischrX,
                                     "x",
                                     1
                                 ];
        If[ boolparent,
            If[ ToLowerCase[model]==="jointmodel",
                ibdprob = calmagicibd[submagicsnp, popDesign, isfounderinbred, isfounderdepth,isoffspringdepth];
                model2 = If[ ibdprob>0.9,
                             "depModel",
                             model
                         ],
                model2 = model
            ];
            submagicsnp = magicImputeFounder[submagicsnp, model2, epsF, eps, popDesign,minphredscore,
                maxfoundererror,foundercallthreshold,isfounderinbred,isfounderdepth,isoffspringdepth,starttime,isprint,isextrareverse];
        ];
        If[ booloff,
            submagicsnp = First[magicImputeOffspring[submagicsnp, model, epsF, eps, popDesign, minphredscore, errorgenobound, imputingbound, 
                isfounderinbred, isfounderdepth, isoffspringdepth, starttime, isprint]];
        ];
        submagicsnp[[3, 2 ;;]] = "NA";
        dataprobset = Table[0, {Length[magicSNP[[2, 2 ;;]]]}];
        dataprobset[[snps]] = calmapdataprobset[submagicsnp, model, epsF, eps, ischrX, minphredscore, isfounderinbred, isfounderdepth, isoffspringdepth];
        temp = Dimensions[dataprobset[[snps]]];
        If[ Length[temp]!=3,
            Print["updatePhasing: dataprobset has wrong dimension ",temp];
            Abort[];
        ];
        {dataprobset,submagicsnp}
    ]    

        
refinePreprocessing[inputmagicSNP_, model_, popDesign_, ischrX_,isfounderinbred_, isfounderdepth_, isoffspringdepth_] :=
    Module[ {magicsnp = inputmagicSNP,deltd, founderHaplo, obsGeno, snpMap, haploMap, nFounder, posA, 
          posX, foundergender, offspringgender, founderid, sampleid},
        magicsnp[[3, 2 ;;]] = If[ ischrX,
                                  "x",
                                  1
                              ];
        magicsnp[[4, 2 ;;]] = Range[Length[magicsnp[[4, 2 ;;]]]];
        {deltd, founderHaplo, obsGeno, snpMap, haploMap, nFounder, posA, 
          posX, foundergender, offspringgender, founderid, sampleid} = 
         transformMagicSNP[magicsnp, isfounderinbred, isfounderdepth, isoffspringdepth];
        refinePreprocessing[nFounder,model, popDesign, isfounderinbred,posA, posX, offspringgender, sampleid]
    ] 
    
refinePreprocessing[nFounder_,model_, popDesign_, isfounderinbred_,posA_, posX_, offspringgender_, sampleid_] :=
    Module[ {ls, samplelabel, maxfraction, continuedmarkovprocess, samplemapR},
        {samplelabel, continuedmarkovprocess} = sampleContinuedPriorProcess[nFounder, popDesign, isfounderinbred,model, posA, posX, offspringgender, sampleid];
        ls = continuedmarkovprocess;
        ls[[All, 2]] = ls[[All, 2, All, 1]];
        maxfraction =  calmaxfraction[ls,ToLowerCase[model]==="depmodel"];
        samplemapR = sampleMapExpansion[nFounder, popDesign, isfounderinbred, posA, posX, offspringgender];
        samplemapR = Mean[Mean[Map[Mean, samplemapR, {2}]]];
        {samplelabel, continuedmarkovprocess, maxfraction,samplemapR,offspringgender}
    ]  

calmapdataprobset[inputmagicSNP_, model_, epsF_, eps_, ischrX_, minphredscore_,isfounderinbred_, isfounderdepth_, isoffspringdepth_] :=
    Module[ {magicsnp = inputmagicSNP, deltd, founderHaplo, obsGeno, snpMap, haploMap, nFounder, posA, posX, foundergender, 
      offspringgender, founderid, sampleid, ismaleX, dataprobset, fhaplos,t},
        magicsnp[[3, 2 ;;]] = If[ ischrX,
                                  "x",
                                  1
                              ];
        magicsnp[[4, 2 ;;]] = Range[Length[magicsnp[[4, 2 ;;]]]];
        {deltd, founderHaplo, obsGeno, snpMap, haploMap, nFounder, posA, 
          posX, foundergender, offspringgender, founderid, sampleid} = 
         transformMagicSNP[magicsnp, isfounderinbred, isfounderdepth, isoffspringdepth];
        If[ ischrX,
            ismaleX = MatchQ[#, "Male" | "male"] & /@ offspringgender,
            ismaleX = Table[False, {Length[sampleid]}];
        ];
        dataprobset = Table[0, {Last[Dimensions[founderHaplo]]}];
        Do[
         fhaplos = {founderHaplo[[All, 1, t]]};
         If[ isoffspringdepth,
             dataprobset[[t]] = First[siteMagicLikelihoodGBS[model, fhaplos,obsGeno[[All, 1, t]], epsF, eps, minphredscore, ismaleX]],
             dataprobset[[t]] = First[siteMagicLikelihood[model, fhaplos, obsGeno[[All, 1, t]],epsF, eps, ismaleX]];
         ], {t, Length[dataprobset]}];
        dataprobset
    ]  
        
calmapdataprobset2[inputmagicSNP_, model_, epsF_, eps_, ischrX_, snps_,snpfphase_, 
    minphredscore_,isfounderinbred_, isfounderdepth_, isoffspringdepth_] :=
    Module[ {magicsnp = inputmagicSNP, deltd, founderHaplo, obsGeno, snpMap, haploMap, nFounder, posA, posX, foundergender, 
      offspringgender, founderid, sampleid, ismaleX, dataprobset, fhaplos,t},
        magicsnp[[3, 2 ;;]] = If[ ischrX,
                                  "x",
                                  1
                              ];
        magicsnp[[4, 2 ;;]] = Range[Length[magicsnp[[4, 2 ;;]]]];
        {deltd, founderHaplo, obsGeno, snpMap, haploMap, nFounder, posA, 
          posX, foundergender, offspringgender, founderid, sampleid} = 
         transformMagicSNP[magicsnp, isfounderinbred, isfounderdepth, isoffspringdepth];
        If[ ischrX,
            ismaleX = MatchQ[#, "Male" | "male"] & /@ offspringgender,
            ismaleX = Table[False, {Length[sampleid]}];
        ];
        dataprobset = Table[0, {Last[Dimensions[founderHaplo]]}];
        Do[
         If[ Head[snpfphase]===Missing,
             fhaplos = {founderHaplo[[All, 1, t]]},
             fhaplos = {t /. snpfphase};
         ];
         If[ isoffspringdepth,
             dataprobset[[t]] = First[siteMagicLikelihoodGBS[model, fhaplos,obsGeno[[All, 1, t]], epsF, eps, minphredscore, ismaleX]],
             dataprobset[[t]] = First[siteMagicLikelihood[model, fhaplos, obsGeno[[All, 1, t]],epsF, eps, ismaleX]];
         ], {t, snps}];
        dataprobset
    ]      
      
iterationsummary[groupindex_,runindex_,kernelid_,starttime_,inputsnpid_,refmap_,temperature_,freeze_,it_,
    snporder_,snpdeltd_,actionls_,windowsizels_,acceptls_,loglls_,loglbefore_,acceptdis_,logldis_] :=
    Module[ {stringprint,figprint,tabcontent,data,gg,tau},
        stringprint = "LinkageGroup" <> ToString[groupindex]<>"_Replicate"<>ToString[runindex]<>"_Kernel"<>ToString[kernelid]<>
              ". Iteration = " <>ToString[it] <> ". Time elapsed = " <>
              ToString[Round[SessionTime[] - starttime, 0.1]] <> " seconds. Temperature = " <> ToString[Round[temperature, 0.001]] <>
              ". logl = " <> ToString[loglbefore];
        data = 100 Join[{0},Accumulate[snpdeltd]];
        gg = {ListPlot[data, PlotRange -> All, PlotMarkers -> {Automatic, 8}, Joined->True, 
                 LabelStyle -> Directive[FontSize -> 12, FontFamily -> "Helvetica", Black],
                 PlotLabel ->"Length = "<>ToString[Round[Last[data],0.1]]<>" cM",
                 Frame -> {{True, False}, {True, False}}, FrameLabel -> {"index", "Marker position (cM)"}]};
        If[ refmap===None,
            figprint = GraphicsRow[gg,ImageSize -> 350],
            data = (inputsnpid[[#]] & /@ snporder[[All, 1]]) /. Flatten[refmap];
            tau = Round[KendallTau[data, Range[Length[data]]], 0.001];
            AppendTo[gg,ListPlot[data,
                     PlotRange -> Automatic, PlotMarkers -> {Automatic, 8},Joined->True, 
                     LabelStyle -> Directive[FontSize -> 12, FontFamily -> "Helvetica", Black],
                     PlotLabel ->"Kendall Tau = "<>ToString[tau],
                     Frame -> {{True, False}, {True, False}},FrameLabel -> {"index", "Reference marker No."}]];
            figprint = GraphicsRow[gg,ImageSize -> 700];
        ];
        If[ temperature>=0&&(logldis==="NA"||temperature>freeze||TrueQ[Max[loglls]-logldis>10^(-5.)]),
            tabcontent = {Round[Mean[#] & /@ windowsizels,0.1], Round[Mean[Boole[#]] & /@ acceptls, 10^(-4.)],loglls};
            tabcontent = Join[{{"NA"}, {acceptdis}, {logldis}},tabcontent, 2];
            {stringprint,tabcontent,figprint},
            {stringprint,figprint}
        ]
    ]
                  
withingroupRefine[{groupindex_,runindex_,kernelid_},initorder_, initdeltd_, snpneighborhood_,inputsnpid_,
    inputrefmap_,inittemperature_,coolingrate_, freeze_,deltloglbound_, itmax_,inputmagicSNP_,model_, popDesign_, epsF_, eps_, ischrX_,
    minphredscore_, foundercallthreshold_,isimputefounder_,isfounderinbred_,isfounderdepth_, isoffspringdepth_, imputingbound_,errorgenobound_,outputfile_] :=
    Module[ {refmap = inputrefmap,magicSNP = inputmagicSNP,snporder, snpdeltd ,snpneighbor, temperature, submagicsnp,temp,
        meanwindowsize0 = 4, count = 0, maxstuck = 3,priorchrlength = 0.2,starttime,nrep,boolparent,booloff,dataprobset, samplelabel, 
        continuedmarkovprocess, maxfraction, samplemapR, offspringgender, nfounder, loglhis,meanwindowsize, outstream, imputestepsize = 3,
        actionls, logldis, acceptdis,loglbefore,logl = -Infinity,windowsizels, acceptls, loglls, summary,it},
        starttime = SessionTime[];
        (*each inter-marker distance follows an exponential distribution with mean priorchrlength in unit of Morgan*)
        {samplelabel, continuedmarkovprocess, maxfraction, samplemapR, offspringgender} = 
            refinePreprocessing[magicSNP, model, popDesign, ischrX,isfounderinbred,isfounderdepth, isoffspringdepth];
        nrep = Length[iterationmonitor]/Length[initorder];
        snporder = initorder[[groupindex]];
        snpdeltd = initdeltd[[groupindex]];
        snpneighbor = snpneighborhood[[groupindex]];
        nfounder = magicSNP[[1, 2]];
        temperature = inittemperature;
        Quiet[Close[outputfile]];
        Quiet[DeleteFile[outputfile]];
        Put[outputfile];
        outstream = OpenWrite[outputfile];
        Write[outstream, {"magicMapRefine-IterativeHistory"}];
        Write[outstream, #] & /@ {{"LinkageGroup",groupindex},{"Replicate",runindex},{"InitTemperature",inittemperature}, {"CoolingRate", coolingrate}};
        If[ temperature<freeze,
            imputestepsize = 5;
             (*When temperature<freeze, snpneighbor or snpneighborhood is not needed*)
            actionls = {"Reverse", "RotateLeft", "RotateRight"},
            actionls = {"ReverseLeftNeighbor","RotateLeftNeighbor", "ReverseRightNeighbor", "RotateRightNeighbor","Reverse", "RotateLeft", "RotateRight"};
        ];
        {windowsizels, acceptls, loglls} = Transpose[Table[List /@ {0, True,"NA"}, {Length[actionls]}]];
        loglls = Flatten[loglls];
        loglbefore = logldis = acceptdis = "NA";
        If[ refmap=!=None,
            refmap = SplitBy[Join[refmap[[2 ;;, ;; 2]], List /@ Range[Length[refmap] - 1],2], #[[2]] &];
            refmap = Map[Rule @@ # &, refmap[[All, All, {1, 3}]], {2}];
        ];
        summary = iterationsummary[groupindex,runindex,kernelid,starttime,inputsnpid,refmap,temperature,freeze,"initial",snporder,snpdeltd,actionls,windowsizels,acceptls,loglls,
            loglbefore,acceptdis,logldis];
        If[ Length[summary]==3,
            iterationmonitor[[nrep (groupindex-1)+runindex]] = Column[{summary[[1]],TableForm[summary[[2]],
                  TableHeadings -> {{"WindowSize", "Accept Ratio", "Ln Likelihood"},Join[{"Distance"}, actionls]},
                 TableSpacing -> {1, 1}, TableAlignments -> Center], summary[[3]]}],
            iterationmonitor[[nrep (groupindex-1)+runindex]] = Column[summary];
        ];
        loglhis = Table[0,{itmax}];
        Do[
         meanwindowsize = meanwindowsize0 + 1/2 temperature;
         If[ temperature<freeze,
             imputestepsize = 5;
             (*When temperature<freeze, snpneighbor or snpneighborhood is not needed*)
             actionls = {"Reverse", "RotateLeft", "RotateRight"},
             actionls = {"ReverseLeftNeighbor","RotateLeftNeighbor", "ReverseRightNeighbor", "RotateRightNeighbor","Reverse", "RotateLeft", "RotateRight"};
         ];
         {snporder[[All, 1]], snpdeltd} = Reverse[#] & /@ {snporder[[All, 1]], snpdeltd};
         If[ True,              
              (*(freeze coolingrate <=temperature<freeze)*)
              (*Mod[Floor[(it + 1)/2], 3] == 1*)
             boolparent = isimputefounder&&(Mod[it,imputestepsize] == 1||freeze coolingrate<=temperature<freeze);
             booloff = (imputingbound<1||errorgenobound<1)&&(Mod[it,imputestepsize] == 1||freeze coolingrate<=temperature<freeze);
             If[ it==1||boolparent||booloff,
                 If[ groupindex==runindex==1,
                     PrintTemporary["{Iteration,Temperature,ParentImpute&Phasing,ErrorDetect,OffspringImpute}=",{it,temperature, boolparent,booloff&&errorgenobound<1,booloff&&imputingbound<1}];
                 ];
                 Quiet[dataprobset = First[updatePhasing[magicSNP, model, popDesign, epsF, eps, ischrX,snporder[[All, 1]], snpdeltd, 
                    minphredscore, foundercallthreshold,isfounderinbred, isfounderdepth, isoffspringdepth, boolparent,booloff,imputingbound,errorgenobound]]];
             ];
         ];
         (*{loglbefore, snpdeltd} = updatemarkerdistanceEM[model,snporder[[All, 1]], snpdeltd, samplelabel, 
           continuedmarkovprocess, dataprobset, samplemapR, ischrX,offspringgender];*)
         If[ temperature<freeze,
             {{loglbefore,logldis},snpdeltd} = updatemarkerdistanceBrent[snporder[[All, 1]], snpdeltd, samplelabel,continuedmarkovprocess, dataprobset,priorchrlength];
             acceptdis =  "BrentMethod",
             {{loglbefore,logldis},snpdeltd,acceptdis} = updatemarkerdistanceMC[snporder[[All, 1]], snpdeltd, samplelabel,continuedmarkovprocess, dataprobset,priorchrlength,temperature];
         ];
         If[ Length[summary]==3,
             {snporder, snpdeltd, windowsizels, acceptls, loglls} = 
                  updatemarkerorder[snporder, snpdeltd, actionls, samplelabel, continuedmarkovprocess, dataprobset, snpneighbor, meanwindowsize,temperature],
             loglls = Table[logldis,{Length[windowsizels]}];
         ];
         Write[outstream, {it, temperature, snporder, snpdeltd,acceptdis,logldis,windowsizels,acceptls,loglls}];
         (*compare logl in iterations with same chromosome directions*)
         If[ it>=3&& temperature<freeze&&Abs[Last[loglls]-loglhis[[it-2]]] < deltloglbound,
             count++,
             count = 0
         ];
         summary = iterationsummary[groupindex,runindex,kernelid,starttime,inputsnpid,refmap,temperature,freeze,it,snporder,snpdeltd,actionls,windowsizels,acceptls,loglls,
             loglbefore,acceptdis,logldis];
         If[ Length[summary]==3,
             iterationmonitor[[nrep (groupindex-1)+runindex]] = Column[{summary[[1]],TableForm[summary[[2]],
                   TableHeadings -> {{"WindowSize", "Accept Ratio", "Ln Likelihood"},Join[{"Distance"}, actionls]},
                  TableSpacing -> {1, 1}, TableAlignments -> Center], summary[[3]]}],
             iterationmonitor[[nrep (groupindex-1)+runindex]] = Column[summary];
         ];
         countmonitor++;
         If[ count == maxstuck,
             Break[]
         ];
         loglhis[[it]] = logl = Last[loglls];
         If[ temperature>0,
             If[ temperature<freeze,
                 temperature *= coolingrate^3,
                 temperature *= coolingrate;
             ];
             If[ temperature<0.01,
                 temperature = 0;
             ];
         ], {it, itmax}];
        Close[outputfile];
        If[ inputrefmap=!=None,
            temp = (inputsnpid[[#]] & /@ snporder[[All, 1]]) /. Flatten[refmap];
            If[ KendallTau[temp, Range[Length[temp]]] < 0,
                {snporder[[All, 1]], snpdeltd} = Reverse[#] & /@ {snporder[[All, 1]], snpdeltd};
            ];
        ];
        Quiet[submagicsnp = Last[updatePhasing[magicSNP, model, popDesign, epsF, eps, ischrX,snporder[[All, 1]], snpdeltd, 
            minphredscore,foundercallthreshold,isfounderinbred, isfounderdepth, isoffspringdepth, isimputeparent,iscorrectoff,imputingbound,errorgenobound]];];
        temp = StringDelete[StringSplit[summary[[1]], "."][[2]], " Iteration = "];
        {logl, snporder, snpdeltd,submagicsnp,temp}
    ]
  
(*refine is a list of {linkagegroup,replication, logl, snporder, snpdeltd,submagicsnp,numberofiteration}*)
(*roughtmap/refinemap has columns "MarkerID","LinkageGroupNo","Position(cM)","InterMarkerFraction"/"InterMarkerDistance(cM)",
                                  "InputMarkerNo","NearestNeighbors","NeighborStrengths"*)                                  
(*to revise for X chromosomes*)
formRefineMap[roughmap_, refine_] :=
    Module[ {ls, map, temp,i,logl},
        If[ Sort[roughmap[[2 ;;, 5]]] != Range[Length[roughmap] - 1],
            Print["formRefineMap: unexpected InputMarkerNo in roughtmap! InputMarkerNo must take integers from 1 to number of input markers!"];
            Abort[];
        ];
        ls = Last[SortBy[#, #[[3]] &]] & /@ SplitBy[refine, First];
        map = SortBy[roughmap[[2 ;;]], #[[5]] &];
        map = Table[
          temp = map[[ls[[i, 4, All, 1]]]];
          temp[[All, 2]] = ls[[i, 1]];
          temp[[All, 3]] = Accumulate[Join[{0}, 100 ls[[i, 5]]]];
          temp[[All, 4]] = Join[{"NA"}, 100 ls[[i, 5]]];
          temp, {i, Length[ls]}];
        logl = Join[{"LG_logLikelihood"}, 
            Flatten[Round[map[[All, All, 2]] /. Thread[ls[[All, 1]] -> ls[[All, 3]]],10^(-2.)]],
            Table["NA", {Count[roughmap[[2 ;;, 2]], "ungrouped"]}]];
        map = Join[roughmap[[{1}]], Flatten[map, 1], Pick[roughmap[[2 ;;]], roughmap[[2 ;;, 2]], "ungrouped"]];
        map[[1, 4]] = "InterMarkerDistance(cM)";
        Join[map,List/@logl,2]
    ]

(*refine is a list of {linkagegroup,replication,logl,snporder,snpdeltd,submagicsnp}*)
formRefineMagicSNP[refine_] :=
    Module[ {refine2, index, ls,i},
        refine2 = Last[SortBy[#, #[[3]] &]] & /@ SplitBy[refine, First];
        index = 6; (*submagicsnp*)
        ls = refine2[[All, index, 2 ;;, 2 ;;]];
        (*set id for linkage groups*)
        Do[ls[[i, 2]] = Table[i, {ls[[i, 2]]}], {i, Length[ls]}];
        ls = Join[List /@ refine2[[1, index, 2 ;;, 1]], Sequence @@ ls, 2];
        ls[[3, 2 ;;]] *= 100;
        Join[{refine2[[1, index, 1]]}, ls]
    ]
  
(*to revise for X chromosomes*)
fillmagicsnp[magicSNP_, refinemap_] :=
    Module[ {ls, newmagicsnp,nfounder,fhaplo,len},
        nfounder = magicSNP[[1, 2]];
        ls = DeleteCases[refinemap[[2 ;;, {1, 2, 5,3,8}]], {_, "ungrouped", ___}];
        newmagicsnp = Join[magicSNP[[{1}]],magicSNP[[2 ;;, Join[{1}, 1 + ls[[All, 3]]]]]];
        newmagicsnp[[2 ;; 4, 2 ;;]] = Transpose[ls[[All, {1, 2, 4}]]];
        newmagicsnp[[3 ;; 4, 1]] = {"Chromosome", "Position(cM)"};
        If[ DeleteCases[ls[[All, 5]], "NA"] =!= {},
            fhaplo = Characters[ToString[#]] & /@ ls[[All, 5]];
            len = Length[fhaplo[[1]]]/nfounder;
            If[ ! IntegerQ[len],
                Print["fillmagicsnp: inconsistent inputput on founder haplotypes!"];
                Abort[];
            ];
            newmagicsnp[[5 ;; 4 + nfounder, 2 ;;]] = Transpose[Map[StringJoin @@ # &, Partition[#, len] & /@ fhaplo, {2}]];
        ];
        newmagicsnp
    ]
  
(*not imputing missing offspring genotypes. 
By default, always imputing missing parnet genotypes*)
Options[magicMapRefine] = 
 Join[FilterRules[Options[magicPairwiseSimilarity], Except[{computingLodType,minLodSaving}]],
      {referenceMap -> None,
      isImputingFounder ->True,
      detectingThreshold -> 0.9,
      imputingThreshold -> 1, 
      nReplicateAnnealing -> 1, 
      initTemperature -> 2,
      coolingRate -> 0.85, 
      freezingTemperature->0.5,
      deltLoglThreshold -> 1, 
      MaxIterations -> 50}
  ]

magicMapRefine[inputroughmap_?(ListQ[#] || StringQ[#] &), inputmagicSNP_?(ListQ[#] || StringQ[#] &), 
    model_String, inputpopDesign_?(ListQ[#] || StringQ[#] &), opts : OptionsPattern[]] :=
    Module[ {roughMap = inputroughmap,magicSNP = inputmagicSNP,popDesign = inputpopDesign,epsF, eps, ischrX = False,isimputefounder,
        isfounderdepth, isoffspringdepth, foundercallthreshold,minphredscore,isfounderinbred,outputid, isprint, isparallel,
        refmap,nreplicate, inittemperature, coolingrate, freeze,deltloglbound, itmax, outputfiles, initorder,background,imputingbound,errorgenobound,
        initdeltd, snpneighborhood, lglist, filelist, refine, refinemap,res,i,outstream,starttime = 0,temp,inputsnpid},
        {epsF, eps} = OptionValue@{founderAllelicError, offspringAllelicError};
        {isfounderdepth, isoffspringdepth, minphredscore,foundercallthreshold} = 
         OptionValue[Thread[sequenceDataOption -> {isFounderAllelicDepth, isOffspringAllelicDepth, minPhredQualScore,priorFounderCallThreshold}]];
        {isfounderinbred, outputid, isprint, isparallel} = OptionValue@{isFounderInbred, outputFileID, isPrintTimeElapsed,isRunInParallel};
        {isimputefounder,imputingbound,errorgenobound,refmap,nreplicate, inittemperature, coolingrate, freeze,deltloglbound, itmax} = 
         OptionValue@{isImputingFounder,imputingThreshold,detectingThreshold,referenceMap,nReplicateAnnealing, initTemperature, coolingRate,
             freezingTemperature,deltLoglThreshold, MaxIterations};
        If[ outputid =!= "",
            outputid = outputid <> "_"
        ];
        outputfiles = outputid<>#&/@{"refiningHistory.txt","refinedLinkageMap.csv","refinedMagicSNP.csv"};
        If[ !MemberQ[{"jointModel","indepModel","depModel"},model],
            Print["magicMapRefine: model has to take \"jointModel\", \"indepModel\", or \"depModel\"."];
            Return[$Failed]
        ];
        If[ StringQ[roughMap],
            If[ !FileExistsQ[roughMap],
                Print["File ", roughMap," does not exist!"];
                Return[$Failed]
            ];
            roughMap = Import[roughMap,"CSV"];
        ];
        If[ StringQ[magicSNP],
            If[ !FileExistsQ[magicSNP],
                Print["File ", magicSNP," does not exist!"];
                Return[$Failed]
            ];
            magicSNP = Import[magicSNP,"CSV"];
        ];
        If[ MatchQ[magicSNP[[3, -1]], "X" | "x"],
            magicSNP[[3, 2 ;;]] = magicSNP[[3, -1]],
            magicSNP[[3, 2 ;;]] = "NA"
        ];
        magicSNP[[4, 2 ;;]] = "NA";
        If[ StringQ[popDesign],
            If[ !FileExistsQ[popDesign],
                Print["File ", popDesign," does not exist!"];
                Return[$Failed]
            ];
            popDesign = Import[popDesign,"CSV"];
        ];
        If[ isprint,
            starttime = SessionTime[];
            Print["magicMapRefine. Start date = ", DateString[], ". Outputfiles = ",outputfiles];
        ];
        inputsnpid = magicSNP[[2,2;;]];
        If[ (Dimensions[roughMap][[2]] >= 5&&SortBy[roughMap[[2 ;;, {1, 5}]], Last][[All, 1]] =!= inputsnpid)||
            (Dimensions[roughMap][[2]] == 3 && Sort[roughMap[[2 ;;, 1]]] =!= Sort[inputsnpid]),
            Print["magicMapRefine: inconsistent markers between initial map and magicsnp!"];
            Abort[];
        ];
        If[ Dimensions[roughMap][[2]] == 3,
            roughMap = Join[roughMap, roughMap[[All, 2 ;; 3]], 2];
            roughMap[[1, 4 ;; 5]] = {"InterMarkerDistance", "InputMarkerNo"};
            roughMap[[2 ;;, 4]] = "NA";
            roughMap[[2 ;;, 5]] = roughMap[[2 ;;, 1]] /.Thread[inputsnpid -> Range[Length[inputsnpid]]];
        ];
        If[ refmap=!=None,
            If[ StringQ[refmap]&&FileExistsQ[refmap],
                refmap = Import[refmap, Path -> Directory[]];
                temp = Complement[inputsnpid, refmap[[2 ;;, 1]]];
                If[ temp =!= {},
                    Print["Markers in pairwise datafile are not in reference map: ",temp, ". referenceMap is reset to None!"];
                    refmap = None;
                ],
                Print["magicMapRefine: file ", refmap," does not exist"];
                Abort[];
            ];
        ];
        {isfounderdepth, isoffspringdepth} = checkOptionValue[magicSNP, isfounderdepth, isoffspringdepth,isfounderinbred, False];
        If[ MemberQ[DeleteCases[roughMap[[2 ;;, 2 ;; 3]], {"ungrouped", _}][[All, 2]], "NA"],
            If[ Dimensions[roughMap][[2]] >5,
                roughMap = calInterSNPsimilarity[roughMap, magicSNP, model, popDesign, epsF,eps, minphredscore, foundercallthreshold, isfounderinbred, 
                  isfounderdepth, isoffspringdepth, isprint],
                Print["magicMapRefine: wrong initial map!"];
            ];
            If[ StringQ[inputroughmap] && FileExistsQ[inputroughmap],
                Export[inputroughmap, roughMap];
            ];
        ];
        {initorder, initdeltd, snpneighborhood} = decomposeRoughMap[roughMap];
        (*If[ MissingQ[initorder],
            temp = DeleteCases[roughMap, _?(MatchQ[#[[2]], "ungrouped"] &)];
            initorder = temp[[2 ;;, 1]] /. Thread[inputsnpid -> Range[Length[inputsnpid]]];
            initorder = SplitBy[Transpose[{initorder, temp[[2 ;;, 2]]}], Last][[All, All,1]];
            initorder = Table[Thread[initorder[[i]] -> Range[Length[initorder[[i]]]]], {i,Length[initorder]}]
        ];*)
        If[ MissingQ[snpneighborhood],
            If[ inittemperature<freeze,
                snpneighborhood = Table[Missing[],{Length[initdeltd]}],
                Print["magicMapRefine: decrease initTemperature T0 so that T0 < freezingTemperature (",freeze,") or provide neigbhors of markers in initial map"];
                Abort[];
            ];
        ];
        (*iterationmonitor and countmonitor have context of "MagicMap`Private`"*)
        iterationmonitor = Table[0, {Length[initorder] nreplicate}];
        countmonitor = 0;
        If[ isprint,
            PrintTemporary["Overall iteration count: ", Text[Style[Dynamic[countmonitor],Blue, 20]], 
                  ". Time elapsed = ", Text[Style[Dynamic[Round[SessionTime[] - starttime, 1], UpdateInterval -> 1],Blue, 20]], " Seconds."];
        ];
        lglist = Reverse[Ordering[Length[#] & /@ initorder]];
        lglist = Flatten[Outer[List, lglist, Range[nreplicate]], 1];
        filelist = "temporary_linkagegroup" <> ToString[#[[1]]] <> "_replicate" <>ToString[#[[2]]] <> ".txt" & /@ lglist;
        filelist = FileNameJoin[{Directory[], #}] & /@ filelist;
        background = If[ nreplicate===1,
                         {{None}},
                         {Append[Table[None, {nreplicate - 1}], LightBlue]}
                     ];
        (*isimputeparent = isimputeparent||(!isfounderinbred);*)
        If[ isparallel,
            SetSharedVariable[iterationmonitor, countmonitor];
            Monitor[
             res = ParallelTable[withingroupRefine[Append[lglist[[i]],$KernelID], initorder, initdeltd,snpneighborhood, inputsnpid,
                 refmap,inittemperature, coolingrate, freeze,deltloglbound,itmax, magicSNP, model, popDesign, epsF, eps, ischrX,
                minphredscore,foundercallthreshold, isimputefounder, isfounderinbred,isfounderdepth, isoffspringdepth,imputingbound,errorgenobound,filelist[[i]]], {i, Length[lglist]}, 
               DistributedContexts -> {"MagicMap`","MagicMap`Private`"}, Method -> "FinestGrained"],
             Column[iterationmonitor, Background -> background,Frame -> All]
             ],
            Monitor[
              res = Table[withingroupRefine[Append[lglist[[i]],$KernelID], initorder, initdeltd,snpneighborhood, inputsnpid,
                  refmap,inittemperature, coolingrate, freeze,deltloglbound,itmax, magicSNP, model, popDesign, epsF, eps, ischrX,
                  minphredscore,foundercallthreshold,isimputefounder,isfounderinbred, isfounderdepth, isoffspringdepth,imputingbound,errorgenobound,filelist[[i]]], {i,Length[lglist]}],
              Column[iterationmonitor, Background -> background, Frame -> All]
              ];
        ];        
        (*If[ isprint,
            Print[Column[iterationmonitor, Background -> {{None, LightGray}}, Frame -> All]];
        ];*)
        Quiet[Close[outputfiles[[1]]]];
        Put[outputfiles[[1]]];
        outstream = OpenAppend[outputfiles[[1]]];
        Do[Write[outstream, #] & /@ ReadList[filelist[[i]]], {i,Length[filelist]}];
        Close[outstream];
        DeleteFile[#] & /@ filelist;        
        (*refine is a list of {linkagegroup,replication, logl, snporder, snpdeltd,submagicsnp,realized_itmax}*)
        (*roughtmap/refinemap has columns "MarkerID","LinkageGroupNo","Position(cM)", "InterMarkerFraction"/"InterMarkerDistance(cM)",
                                          "InputMarkerNo","NearestNeighbors","NeighborLodscores"*)
        refine = Join[lglist, res, 2];
        refine = SortBy[refine,#[[;;2]]&];
        If[ isprint,
            replicatemapplot[nreplicate,refine,inputsnpid,refmap];
        ];
        refinemap = formRefineMap[roughMap, refine];
        magicSNP = formRefineMagicSNP[refine];
        csvExport[outputfiles[[2]], refinemap];
        csvExport[outputfiles[[3]], magicSNP];
        (*Put[magicSNP,refinemap,roughMap, refine,"temp.txt"];*)
        If[ isprint,
            Print["# iterations = ", SplitBy[refine[[All, {1,2,-1}]],#[[;;2]]&][[All, All, -1]]];
            Print["Done! Finished date =",DateString[], ". \tTime elapsed in total = ", Round[SessionTime[] - starttime,0.1], " Seconds."];
        ];
        outputfiles
    ]

replicatemapplot[nreplicate_,refine_,inputsnpid_,refmap_] :=
    Module[ {ls,gg,i},
        ls = Last[SortBy[#, #[[3]] &]] & /@ SplitBy[refine, First];
        If[ refmap===None,
            gg = {GraphicsRow[{mymapplot[100 Join[{0},Accumulate[#]]&/@ls[[All, 5]],{"index", "Marker position (cM)"},False]}, 
             PlotLabel ->Text[Style["Final LinkageMap. logl = "<>ToString[Round[ls[[All,3]],0.1]], Blue, 14]],
             ImageSize -> 500]},
            gg = {GraphicsRow[{mymapplot[100 Join[{0},Accumulate[#]]&/@ls[[All, 5]],{"index", "Marker position (cM)"},False],
                mymapplot[ls[[All, 4, All, 1]],{"Estimated ordering", "Reference ordering"}, inputsnpid, refmap]}, 
             PlotLabel ->Text[Style["Final LinkageMap. logl = "<>ToString[Round[ls[[All,3]],0.1]], Blue, 14]],
             ImageSize -> 1000]};
        ];
        If[ nreplicate>1,
            ls = Transpose[Partition[refine, nreplicate]];
            If[ refmap===None,
                gg = Join[Table[
                   GraphicsRow[{mymapplot[100 Join[{0},Accumulate[#]]&/@ls[[i,All, 5]],{"index", "Marker position (cM)"},False]}, 
                    PlotLabel -> Text[Style["Replicate" <> ToString[i]<>". logl = "<>ToString[Round[ls[[i,All,3]],0.1]], Blue, 14]],
                    ImageSize -> 500], {i, Length[ls]}], gg],
                gg = Join[Table[
                   GraphicsRow[{mymapplot[100 Join[{0},Accumulate[#]]&/@ls[[i,All, 5]],{"index", "Marker position (cM)"},False], 
                       mymapplot[ls[[i, All, 4, All, 1]],{"Estimated ordering", "Reference ordering"}, inputsnpid, refmap]}, 
                    PlotLabel -> Text[Style["Replicate" <> ToString[i]<>". logl = "<>ToString[Round[ls[[i,All,3]],0.1]], Blue, 14]],
                    ImageSize -> 1000], {i, Length[ls]}], gg];
            ];
        ];
        Print[Column[gg, Background -> Append[Table[None, {nreplicate}], LightBlue],Frame -> All]];
    ]    
        
mymapplot[inputdata_,xylab_,isorder_] :=
    Module[ {data = inputdata, gg, ls, ii,lab,tau},
        data = Table[If[ Depth[data[[ii]]] == 2,
                         Transpose[{Range[Length[data[[ii]]]], data[[ii]]}],
                         data[[ii]]
                     ], {ii, Length[data]}];
        data[[All, All, 1]] += Most[Accumulate[Prepend[data[[All, -1, 1]], 0]]];
        If[ isorder,
            tau = Round[KendallTau @@ Transpose[#] & /@ data, 0.001];
            lab = "Kendall Tau = "<>ToString[tau],
            lab = "Length (cM) = "<>ToString[Round[data[[All, -1, 2]], 0.1]];
        ];
        gg = ListPlot[data, PlotRange -> All, PlotLabel->lab,PlotMarkers -> {Automatic, 8},            
           Frame -> {{True, False}, {True, False}}, FrameLabel ->xylab,
           If[ isorder,
               Joined->False,
               Joined->True
           ], 
          LabelStyle -> Directive[FontSize -> 13, FontFamily -> "Helvetica", Black]];
        If[ Length[data] > 1,
            ls = Flatten[data[[All, {1, -1}, 1]]][[2 ;;-2 ]];
            ls = Append[Mean[#] & /@ Partition[ls, 2],data[[-1,-1,1]]];
            gg = Show[gg, ListPlot[Thread[{#, {Min[data[[All, All, 2]]],Max[data[[All, All, 2]]]}}] & /@ ls, Joined -> True,PlotStyle -> Directive[GrayLevel[0.7],Dashed]]]
        ];
        gg
    ]    
        
mymapplot[inputdata_, xylab_, inputsnpid_, inputrefmap_] :=
    Module[ {refmap = inputrefmap,data, gg, ls},
        refmap = inputrefmap;
        refmap = SplitBy[Join[refmap[[2 ;;, ;; 2]], List /@ Range[Length[refmap] - 1],2], #[[2]] &];
        refmap = Map[Rule @@ # &, refmap[[All, All, {1, 3}]], {2}];
        data = (inputsnpid[[#]] & /@ inputdata) /. Flatten[refmap];
        gg = mymapplot[data, xylab, True];
        If[ Length[refmap] > 1,
            ls = Accumulate[Length[#] & /@ refmap];
            ls[[;;-2]]+=0.5;
            gg = Show[gg, ListPlot[Thread[{{Min[data], Max[data]}, #}] & /@ ls,Joined -> True, PlotStyle -> Directive[GrayLevel[0.7],Dashed]]]
        ];
        gg
    ]
          
Options[magicMap] = DeleteDuplicates[Flatten[Options[#] & /@ {magicPairwiseSimilarity, magicMapConstruct,magicMapRefine}]]

magicMap[magicSNP_?(ListQ[#] || StringQ[#] &), model_String, popDesign_?(ListQ[#] || StringQ[#] &), ngroup_Integer,opts : OptionsPattern[]] :=
    Module[ {isprint,pairwisedatafile, initmapfile, refinemapfile},
        isprint = OptionValue[isPrintTimeElapsed];
        If[ isprint,
            Print["--------------------------------------------------Calculate PairwiseFraction----------------------------------------------------------"];
        ];
        pairwisedatafile = magicPairwiseSimilarity[magicSNP, model, popDesign,FilterRules[{opts}, Options[magicPairwiseSimilarity]]];
        If[ isprint,
            Print["-----------------------------------------------------Construct LinkageMap-------------------------------------------------------------"];
        ];
        initmapfile = magicMapConstruct[pairwisedatafile, ngroup,FilterRules[{opts}, Options[magicMapConstruct]]];
        If[ isprint,
            Print["-------------------------------------------------------Refine LinkageMap-------------------------------------------------------------"];
        ];
        refinemapfile = magicMapRefine[initmapfile, magicSNP, model, popDesign,FilterRules[{opts}, Options[magicMapRefine]]];
        If[ isprint,
            Print["------------------------------------------------------------End---------------------------------------------------------------------"];
        ];
        {pairwisedatafile, initmapfile, refinemapfile}
    ]
          
(************************************************************************************************)
  
(*Here mfgl denotes the mean number of possible FGLs along a chromosome within an individual
Thus, mfgl =2 for a F1 family with outbred parents, rather than mfgl=4.*)
toRecomMorgan[f_, mapR_,mfgl_] :=
    (-Log[1 - mfgl/(mfgl - 1) f]) (mfgl - 1)/(mfgl mapR)
toRecomFraction[d_, mapR_, mfgl_] :=
    (mfgl - 1)/mfgl (1 - Exp[-mfgl/(mfgl - 1) mapR d])

sampleMapExpansion[nFounder_, popDesign_, isfounderinbred_, posA_, posX_, samplegender_] :=
    Module[ {pedigreekey = "Pedigree-Information", res, isPedigree, 
      pedigree, sampleInfor, indlist, founderFGL, boolls, rule, temp, 
      samplememberid, malepos, nonmalepos, juncdist, mapR,isautosome},
        isPedigree = VectorQ[First[popDesign]] && popDesign[[1, 1]] == pedigreekey;
        If[ isPedigree,
            {pedigree, sampleInfor} = Rest[splitPedigreeInfor[popDesign]];
            res = ConstantArray[0, {Length[sampleInfor] - 1, Length[posA] + Length[posX]}];
            indlist = Union[sampleInfor[[2 ;;, 2]]];
            (*inbred founder parents*)
            founderFGL = 
             If[ isfounderinbred,
                 Transpose[{Range[nFounder], Range[nFounder]}],
                 Partition[Range[2 nFounder], 2]
             ];
            boolls = 
             If[ posX =!= {},
                 If[ posA =!= {},
                     {True, False},
                     {False}
                 ],
                 {True}
             ];
            rule = Table[
              temp = pedIdentityPrior[pedigree, founderFGL, isautosome, indlist];
              (*temp[[i,2]]=memberid,temp[[i,6]]=R^m, and temp[i,7]]=R^p*)
              Thread[temp[[2 ;;, 2]] -> temp[[2 ;;, {6, 7}]]], {isautosome,boolls}];
            samplememberid = sampleInfor[[2 ;;, 2]];
            If[ posA =!= {},
                res[[All, posA]] = samplememberid /. rule[[1]];
            ];
            If[ posX =!= {},
                res[[All, posX]] = samplememberid /. rule[[-1]];
                malepos = Position[samplegender, "Male"];
                nonmalepos = Complement[Range[Length[samplegender]], malepos];
                res[[malepos, posX]] = res[[malepos, posX, 1]];
            ],
            res = ConstantArray[0, {Length[samplegender],Length[posA] + Length[posX]}];
            (*juncdist={{inbred,j1122mp,j1211mp,j1213mp,j1222mp,
            j1232mp}_autosome,{inbred,j1122mp,j1211mp,j1213mp,j1222mp,
            j1232mp}_sex}*)
            If[ VectorQ[popDesign, StringQ],
                juncdist = {magicOrigPrior[nFounder, popDesign, isfounderinbred]};
                If[ posX =!= {},
                    AppendTo[juncdist, magicOrigPriorXY[nFounder, popDesign, isfounderinbred]]
                ],
                juncdist = popDesign;
            ];
            mapR = {2 #[[5]] + #[[2]] + #[[6]], 2 #[[3]] + #[[2]] + #[[4]]} & /@ juncdist;
            res[[All, posA]] = ConstantArray[mapR[[1]], {Length[samplegender], Length[posA]}];
            If[ posX =!= {},
                res[[All, posX]] = ConstantArray[mapR[[-1]], {Length[samplegender], Length[posX]}];
                malepos = Flatten[Position[samplegender, "Male"]];
                res[[malepos, posX]] = res[[malepos, posX, {1}]]
            ];
        ];
        res
    ]
             
origDiPosteriorDecoding[startProb_, tranProb_, dataProb_] :=
    Module[ {chr},
        Table[CtDiPosteriorDecoding[startProb[[chr]], tranProb[[chr]],dataProb[[chr]]], {chr, Length[dataProb]}]
    ]
    
indDiposteriorprob[ind_, model_,founderHaplo_, derivedGeno_, obsGeno_, epsF_,
   eps_, minphredscore_, posA_, posX_, offspringgender_, sampleLabel_,
   sampleMarkovProcess_, isoffspringdepth_] :=
    Module[ {haplocode, diplocode, startProb, tranProb, dataProb, logl, 
      diposteriorprob},
        {haplocode, diplocode} = sampleLabel[[ind + 1, 4 ;; 5]];
        {startProb, tranProb} = sampleLabel[[ind + 1, 2]] /. sampleMarkovProcess;
        If[ ! OrderedQ[haplocode],
            {startProb, tranProb} = relabelMarkovProcess[{startProb, tranProb}, haplocode, diplocode];
        ];
        If[ isoffspringdepth,
            dataProb = lineMagicLikelihoodGBS[model,founderHaplo, derivedGeno, obsGeno[[ind]], 
              epsF, eps, minphredscore, posA, posX, offspringgender[[ind]]],
            dataProb = lineMagicLikelihood[model,founderHaplo, obsGeno[[ind]], epsF, eps, 
               posA, posX, offspringgender[[ind]]];
        ];
        {logl, diposteriorprob} = Transpose[origDiPosteriorDecoding[startProb, tranProb, dataProb]];
        {logl, diposteriorprob}
    ]



getgametetran[model_,nFounder_, posA_, posX_, offspringgender_] :=
    Module[ {states, diplocount, haplocount, res, ngamete, malepos},
        If[ ToLowerCase[model] === "depmodel",
            res = ConstantArray[1 - IdentityMatrix[nFounder], {Length[offspringgender],Length[posA] + Length[posX]}];
            res = Map[Flatten, res, {2}];
            ngamete = Table[Length[offspringgender],{Length[posA] + Length[posX]}],
            states = origGenotype[nFounder][[1, 2]];
            diplocount = Total[Sign[Abs[Outer[Subtract, states, states, 1, 1]]], {3}];
            haplocount = 1 - IdentityMatrix[nFounder];
            res = ConstantArray[diplocount, {Length[offspringgender],Length[posA] + Length[posX]}];
            malepos = Flatten[Position[offspringgender, "Male"]];
            res[[malepos, posX]] = haplocount;
            res = Map[Flatten, res, {2}];
            ngamete = ConstantArray[2, {Length[offspringgender], Length[posA] + Length[posX]}];
            ngamete[[malepos, posX]] = 1;
            ngamete = Total[ngamete];
        ];
        {res, ngamete}
    ]

expectdeltd[model_,founderHaplo_, derivedGeno_, obsGeno_, epsF_, eps_, 
  minphredscore_, posA_, posX_, offspringgender_, sampleLabel_, 
  sampleMarkovProcess_, samplemapR_, isoffspringdepth_] :=
    Module[ {trancount, ngamete, nFounder, diposteriorprob, res, avgtran, 
      logl, fraction, deltd, ind,ch},
        nFounder = Length[founderHaplo];
        {trancount, ngamete} = getgametetran[model,nFounder, posA, posX, offspringgender];
        Monitor[res = Table[
           {logl, diposteriorprob} = indDiposteriorprob[ind, model, founderHaplo, derivedGeno, obsGeno,
             epsF, eps, minphredscore, posA, posX, offspringgender, 
             sampleLabel, sampleMarkovProcess, isoffspringdepth];
           diposteriorprob = Map[Flatten, diposteriorprob, {2}];
           avgtran = Table[diposteriorprob[[ch]].trancount[[ind, ch]], {ch, Length[diposteriorprob]}];
           {logl, avgtran}, {ind, Length[obsGeno]}], 
         ProgressIndicator[ind, {1, Length[obsGeno]}]];
        {logl, avgtran} = Transpose[res];
        logl = Total[logl];
        fraction = (Total[avgtran])/(ngamete);
        deltd = (-Log[1 - nFounder/(nFounder - 1) fraction]) (nFounder-1)/(nFounder samplemapR);
        {logl, deltd}
    ]

inferchrdeltd[inputmagicSNP_, chr_,popDesign_, model_, epsF_, eps_, 
  minphredscore_, isfounderinbred_, isfounderdepth_, 
  isoffspringdepth_, isprint_, deltloglthreshold_, maxIteration_,starttime_] :=
    Module[ {magicSNP,deltd, founderHaplo, obsGeno, snpMap, haploMap, nFounder, 
      posA, posX, foundergender, offspringgender, founderid, sampleid, 
      deltlogl, history, derivedGeno, samplemapR, sampleLabel, len,gg,
      sampleMarkovProcess, logl, newdeltd,it,isdepmodel},
        magicSNP = getsubMagicSNP[inputmagicSNP, {chr}, All];
        {deltd, founderHaplo, obsGeno, snpMap, haploMap, nFounder, posA, 
          posX, foundergender, offspringgender, founderid, sampleid} = 
         transformMagicSNP[magicSNP, isfounderinbred, isfounderdepth,isoffspringdepth];
        isdepmodel = ToLowerCase[model] === "depmodel";
        derivedGeno = getDerivedGenotype[founderHaplo, isdepmodel,True];
        samplemapR = sampleMapExpansion[nFounder, popDesign, isfounderinbred, posA, posX, offspringgender];
        samplemapR = Mean[Map[Mean, samplemapR, {2}]];
        history = Table[0, {maxIteration + 1}];
        history[[1]] = {"Initial", deltd};
        Do[
         If[ isprint,
             len = Round[Total[Flatten[{history[[it-1,2]]}]] 100,0.1];
             PrintTemporary["Time elapsed ", 
               Round[SessionTime[] - starttime, 0.1], " seconds.  logl = ", 
               history[[it - 1, 1]], ". length = ", len," cM. Starting iteration ", it - 1, "."];
         ];
         {sampleLabel, sampleMarkovProcess} = sampleDiscretePriorProcess[nFounder, popDesign, isfounderinbred, model, 
           posA, posX, offspringgender, sampleid,deltd];
         Quiet[{logl, newdeltd} = expectdeltd[model,founderHaplo, derivedGeno, obsGeno, epsF, eps,minphredscore, posA, posX, 
           offspringgender, sampleLabel,sampleMarkovProcess, samplemapR, isoffspringdepth];];
         logl = Total[logl];
         history[[it]] = {logl, deltd};
         deltlogl = logl - history[[it - 1, 1]];
         gg = {ListPlot[history[[;; it, 1]], Joined -> True,PlotMarkers -> {Automatic, 8},Frame -> {{True, False}, {True, False}},FrameLabel -> {"Iteration", "logl"}],
                  ListPlot[100 Total[history[[;; it, 2, 1]], {2}], Joined -> True,PlotMarkers -> {Automatic, 8},Frame -> {{True, False}, {True, False}},FrameLabel -> {"Iteration", "Total length (cM)"}]};
         gg = Show[#, PlotRange -> All, LabelStyle ->Directive[FontSize -> 13, FontFamily -> "Helvetica", Black]] & /@gg;
         iterationmonitor[[chr]] = GraphicsRow[gg, ImageSize -> 500, PlotLabel -> "Chromosome " <> ToString[chr]];
         countmonitor++;
         If[ deltlogl < 0 || Abs[deltlogl] < deltloglthreshold,
             history = Take[history, it];
             Break[];
         ];
         deltd = newdeltd, {it, 2, maxIteration + 1}];
        Rest[Append[history, {"Lastproposal", newdeltd}]]
    ]

Options[magicLinkage] = {
    founderAllelicError -> 0.005,
    offspringAllelicError -> 0.005,
    isFounderInbred ->True,
    sequenceDataOption ->{
        isFounderAllelicDepth -> Automatic,
        isOffspringAllelicDepth -> Automatic,
        minPhredQualScore -> 30,
        priorFounderCallThreshold -> 0.99
        },
    linkageGroupSet->All,
    deltLoglThreshold -> 1,
    isRunInParallel -> True,
    MaxIterations -> 50,
    outputFileID -> "",
    isPrintTimeElapsed -> True
    }
  
magicLinkage[inputmagicSNP_?(ListQ[#] || StringQ[#] &),model_String, inputpopDesign_?(ListQ[#] || StringQ[#] &), opts : OptionsPattern[]] :=
    Module[ {magicSNP = inputmagicSNP,popDesign = inputpopDesign,epsF,eps,isfounderdepth,isoffspringdepth,minphredscore,foundergenocallbound,
        isfounderinbred,chrsubset,deltloglbound,maxit,outputid,isprint,isparallel,
        starttime, chrs, history, deltd, ls,map,chr,outfiles,i},
        {epsF,eps} = OptionValue@{founderAllelicError,offspringAllelicError};
        {isfounderdepth,isoffspringdepth,minphredscore,foundergenocallbound} =
            OptionValue[Thread[sequenceDataOption -> {isFounderAllelicDepth,isOffspringAllelicDepth,minPhredQualScore,priorFounderCallThreshold}]];
        {isfounderinbred,chrsubset,deltloglbound,maxit,outputid,isprint,isparallel} = 
            OptionValue@{isFounderInbred,linkageGroupSet,deltLoglThreshold,MaxIterations,outputFileID,isPrintTimeElapsed,isRunInParallel};
        If[ outputid=!="",
            outputid = outputid<>"_"
        ];
        outfiles = outputid <> # & /@ {"magicLinkageMap.csv", "EMhistory.csv"};
        If[ !MemberQ[{"jointModel","indepModel","depModel"},model],
            Print["magicLinkage: model has to take \"jointModel\", \"indepModel\", or \"depModel\"."];
            Return[$Failed]
        ];
        If[ StringQ[magicSNP],
            If[ !FileExistsQ[magicSNP],
                Print["File ", magicSNP," does not exist!"];
                Return[$Failed]
            ];
            magicSNP = Import[magicSNP,"CSV"];
        ];
        If[ StringQ[popDesign],
            If[ !FileExistsQ[popDesign],
                Print["File ", popDesign," does not exist!"];
                Return[$Failed]
            ];
            popDesign = Import[popDesign,"CSV"];
        ];
        If[ isprint,
            starttime = SessionTime[];
            Print["magicLinkage. Start date = ", DateString[], ". Outputfiles = ", outfiles];
        ];
        {isfounderdepth, isoffspringdepth} = checkOptionValue[magicSNP, isfounderdepth, isoffspringdepth,isfounderinbred, isprint];
        SNPValidation[magicSNP, isfounderinbred, isfounderdepth,isoffspringdepth];
        chrs = SplitBy[magicSNP[[3, 2 ;;]]][[All, 1]];
        chrsubset = Range[Length[chrs]][[chrsubset]];
        iterationmonitor = Table[0, {Length[chrs]}];
        countmonitor = 0;
        If[ isprint,
            PrintTemporary["Overall iteration count: ", Text[Style[Dynamic[countmonitor], Blue, 20]], ". Time elapsed = ",
                Text[Style[Dynamic[Round[SessionTime[] - starttime, 1], UpdateInterval -> 1],Blue, 20]], " Seconds."];
        ];
        If[ isparallel,
            SetSharedVariable[iterationmonitor, countmonitor];
            Monitor[history = ParallelTable[
               inferchrdeltd[magicSNP, chr, popDesign, model, epsF, eps,minphredscore, 
                isfounderinbred, isfounderdepth, isoffspringdepth, False, deltloglbound, maxit, starttime], {chr,chrsubset}, 
               DistributedContexts -> {"MagicMap`", "MagicMap`Private`","Global`"}, Method -> "FinestGrained"], 
             Column[DeleteCases[iterationmonitor, 0], Background -> {{None, LightBlue}}, Frame -> All]],
            Monitor[history = Table[
               inferchrdeltd[magicSNP, chr, popDesign, model, epsF, eps, minphredscore, 
                   isfounderinbred, isfounderdepth,isoffspringdepth, False, deltloglbound, maxit, starttime], {chr,chrsubset}], 
             Column[DeleteCases[iterationmonitor, 0],Background -> {{None, LightBlue}}, Frame -> All]]
        ];
        If[ isprint,
            Print[Column[DeleteCases[iterationmonitor, 0],Background -> {{None, LightBlue}}, Frame -> All]];
        ];
        deltd = Flatten[#] & /@ history[[All, -1, 2]];
        map = Transpose[magicSNP[[2 ;; 4]]];
        map[[1, 3]] = "position(cM)";
        (*100 to change from Morgan to centiMorgan*)
        map[[2 ;;, 3]] = 100 Flatten[Join[{0}, Accumulate[#]] & /@ deltd];
        chrs = Tally[magicSNP[[3, 2 ;;]]][[All, 1]];
        ls = Table[
           ls = history[[i]];
           ls[[All, 2]] = ls[[All, 2, 1]] 100;
           ls = Transpose[{"Iteration" <> ToString[#] & /@Range[0, Length[ls] - 1], Table[chrsubset[[i]], {Length[ls]}], 
              Total[ls[[All, 2]], {2}], ls[[All, 1]], toDelimitedString[N[Round[ls[[All, 2]], 10^(-5)]]]}];
           ls, {i, Length[history]}];
        ls = Join[{{"Iteration No.", "Chromosome", "Chromosome Length (cM)","logl", "Inter-marker distance(cM)"}}, Flatten[ls, 1]];
        csvExport[outfiles[[1]], map];
        csvExport[outfiles[[2]], ls];
        If[ isprint,
            Print["Done! Finished date =", DateString[], ". \tTime elapsed in total = ", 
              Round[SessionTime[] - starttime, 0.1], " Seconds."];
        ];
        outfiles
    ]
    
plotMapComparison[inputestmap_, inputrefmap_, isordering_,linestyle_,opts : OptionsPattern[]] :=
    Module[ {estmap = inputestmap,refmap = inputrefmap, temp, refrule,  isexistungroup, nungroup,index, order, 
      pos, res, data, y00,xmin, xmax, ymin, ymax, g1, g2, gg,g2yy,i},
        If[ StringQ[refmap],
            If[ !FileExistsQ[refmap],
                Print["File ", refmap," does not exist!"];
                Return[$Failed]
            ];
            refmap = Import[refmap,"CSV"];
        ];
        If[ StringQ[estmap],
            If[ !FileExistsQ[estmap],
                Print["File ", estmap," does not exist!"];
                Return[$Failed]
            ];
            estmap = Import[estmap,"CSV"];
        ];
        temp = Complement[refmap[[2 ;;, 1]], estmap[[2 ;;, 1]]];
        refmap = Join[refmap[[{1}]], Select[refmap[[2 ;;]], ! MemberQ[temp, #[[1]]] &]];
        If[ isordering,
            refmap = refmap[[All, ;; 2]];
            estmap = estmap[[All, ;; 2]],
            refmap = refmap[[All, ;; 3]];
            estmap = estmap[[All, ;; 3]];
        ];
        temp = SplitBy[refmap[[2 ;;]], #[[2]] &];
        If[ ! isordering,
            temp[[All, All, 3]] += Join[{0}, Most[Accumulate[temp[[All, -1, 3]]]]]
        ];
        refmap[[2 ;;]] = Flatten[temp, 1];
        refrule = SplitBy[Join[refmap[[2 ;;, ;; 2]],List /@ Range[Length[refmap] - 1], 2], #[[2]] &];
        refrule = Map[Rule @@ # &, refrule[[All, All, {1, 3}]], {2}];
        estmap = SplitBy[estmap[[2 ;;]], #[[2]] &];
        isexistungroup = MatchQ[estmap[[-1, 1, 2]], "ungrouped"];
        nungroup = If[ isexistungroup,
                       Length[estmap[[-1]]],
                       0
                   ];
        index = estmap[[All, All, 1]] /. Flatten[refrule];
        If[ isexistungroup,
            order = Append[Ordering[Median[#] & /@ Most[index]], Length[index]],
            order = Ordering[Median[#] & /@ index]
        ];
        {estmap, index} = #[[order]] & /@ {estmap, index};
        temp = If[ isexistungroup,
                   Most[index],
                   index
               ];
        pos = Flatten[Position[KendallTau[#, N[Range[Length[#]]]] & /@ temp, _?Negative]];
        index[[pos]] = Reverse[#] & /@ index[[pos]];
        estmap[[pos]] = Table[
            temp = Reverse[estmap[[pos[[i]]]]];
            If[ ! isordering,
                temp[[All, 3]] = Join[{0},Accumulate[Reverse[Differences[estmap[[pos[[i]], All, 3]]]]]]
            ];
            temp, {i, Length[pos]}];
        temp = If[ isexistungroup,
                   Most[estmap],
                   estmap
               ];
        If[ ! isordering,
            temp[[All, All, 3]] += Join[{0}, Most[Accumulate[temp[[All, -1, 3]]]]];
            g2yy = temp[[All,-1,3]];
        ];
        If[ isexistungroup,
            estmap[[;; -2]] = temp,
            estmap = temp;
        ];
        estmap = Flatten[MapThread[Join[Transpose[{#1, Range[Length[#1]]}], #2, 2] &, {index,estmap}], 1];
        estmap[[All, 2]] = Range[Length[estmap]];   
        (*set order of ungroupped markers = -1cM*)
        If[ isexistungroup,
            If[ isordering,
                estmap[[-nungroup;;,2]] = y00 = -Ceiling[(Length[estmap]-nungroup)/25],
                estmap[[-nungroup;;,5]] = y00 = -Max[g2yy]/25;
            ],
            estmap[[-nungroup;;,2]] = estmap[[-nungroup;;,5]] = y00 = 0
        ];
        estmap = SortBy[estmap, First];
        res = ConstantArray[0, {Length[refmap], 9}];
        res[[All, 1]] = Join[{"No"}, Range[Length[refmap] - 1]];
        If[ isordering,
            res[[All, 5 ;; 8]] = Join[{{"No", "estorder", "SNP", "LinkageGroup"}}, estmap];
            res[[All, 2 ;; 3]] = refmap,
            res[[All, 5 ;; 9]] = Join[{{"No", "estorder", "SNP", "LinkageGroup", "Position(cM)"}},estmap];
            res[[All, 2 ;; 4]] = refmap;
        ];
        res[[2 ;;, 9]] = res[[2 ;;, 9]] /. {"NA" -> Missing[]};
        res = SplitBy[res[[2 ;;]], #[[3]] &];
        If[ isordering,
            data = res[[All, All, {5, 6}]];
            {xmin, xmax} = # @@ data[[All, All, 1]] & /@ {Min, Max};
            {ymin, ymax} = # @@ data[[All, All, 2]] & /@ {Min, Max};
            temp = Accumulate[Length[#] & /@ index] + 0.5;
            If[ isexistungroup,
                temp = Most[temp]
            ];
            g1 = ListPlot[Thread[{{xmin, xmax}, #}] & /@ Prepend[temp,0], Joined -> True, PlotStyle -> linestyle];
            temp = Accumulate[Length[#] & /@ res] + 0.5;
            g2 = ListPlot[Thread[{#, {0, ymax}}] & /@ Prepend[temp,0], Joined -> True, PlotStyle -> linestyle];
            gg = Show[ListPlot[data, opts,                
                    Frame -> {{True, False}, {True,False}}, AxesOrigin -> {0, 0.9 y00}, Axes -> None], g1, g2],            
            (*{"chrom","Position(OptionalColumn)","LinkageGroup","Position(cM)"}*)
            data = res[[All, All, {4, 9}]] /. {Missing[] -> 0};
            {xmin, xmax} = # @@ data[[All, All, 1]] & /@ {Min, Max};
            {ymin, ymax} = # @@ data[[All, All, 2]] & /@ {Min, Max};
            g1 = ListPlot[Thread[{{xmin, xmax}, #}] & /@ Prepend[g2yy,0], Joined -> True,PlotStyle -> linestyle];
            temp = Max[#] & /@ data[[All, All, 1]];
            g2 = ListPlot[Thread[{#, {0, ymax}}] & /@ Prepend[temp,xmin], Joined -> True, PlotStyle -> linestyle];
            gg = Show[ListPlot[data, opts,
                    Frame -> {{True, False}, {True,False}}, AxesOrigin -> {0, 0.9 y00}, Axes -> None], g1, g2]
        ];
        gg
    ]    
  
Options[plotHeatMap] = Join[Options[MatrixPlot], {rescaleSimilarity -> True,linkageGroupSet->All}];

plotHeatMap[inputmtx_?(ArrayQ[#, 2] &), order_?(MatchQ[#, {{_Integer ...} ...}] &),opts : OptionsPattern[]] :=
    Module[ {mtx = inputmtx, ii, aa, len, isreverse, isscale, datarescale,mesh},
        {isreverse, isscale, datarescale} = OptionValue@{DataReversed, ColorFunctionScaling, rescaleSimilarity};
        If[ datarescale,
            mtx = (mtx - Min[mtx])/(Max[mtx] - Min[mtx]);
        ];
        ii = Flatten[order];
        aa = mtx[[ii, ii]];
        len = Length[#] & /@ order;
        mesh = {Most[Accumulate[If[ isreverse,
                                    Reverse[len],
                                    len
                                ]]], 
          Most[Accumulate[len]]};
        MatrixPlot[aa, Sequence @@ FilterRules[{opts}, Options[MatrixPlot]],
          DataReversed -> isreverse,FrameLabel -> {"Marker index", "Marker index"}, ImageSize -> 400, PlotRange -> All,
         LabelStyle -> Directive[Black, FontFamily -> "Helvetica", FontSize -> 12], MaxPlotPoints -> Infinity, 
         ColorFunctionScaling -> isscale, ColorFunction -> Hue,Mesh -> mesh, MeshStyle -> Directive[White]]
    ]

plotHeatMap[inputuppermtx_?(ArrayQ[#, 2] &), inputlowmtx_?(ArrayQ[#, 2] &), 
    order_?(MatchQ[#, {{_Integer ...} ...}] &),opts : OptionsPattern[]] :=
    Module[ {uppermtx = inputuppermtx, lowmtx = inputlowmtx, ii, aa, len, 
      isreverse, isscale, datarescale, mesh},
        {isreverse, isscale, datarescale} = OptionValue@{DataReversed, ColorFunctionScaling, rescaleSimilarity};
        If[ datarescale,
            {uppermtx, lowmtx} = (# - Min[#])/(Max[#] - Min[#]) & /@ {uppermtx, lowmtx}
        ];
        ii = Flatten[order];
        If[ isreverse,
            aa = UpperTriangularize[lowmtx[[ii, ii]]] + LowerTriangularize[uppermtx[[ii, ii]]],
            aa = UpperTriangularize[uppermtx[[ii, ii]]] + LowerTriangularize[lowmtx[[ii, ii]]];
        ];
        len = Length[#] & /@ order;
        mesh = {Most[Accumulate[If[ isreverse,
                                    Reverse[len],
                                    len
                                ]]], 
          Most[Accumulate[len]]};
        MatrixPlot[aa, Sequence @@ FilterRules[{opts}, Options[MatrixPlot]],
           DataReversed -> isreverse,FrameLabel -> {"Marker index", "Marker index"}, ImageSize -> 400, PlotRange -> All,
          LabelStyle -> Directive[Black, FontFamily -> "Helvetica", FontSize -> 12], MaxPlotPoints -> Infinity, 
          ColorFunctionScaling -> isscale, ColorFunction -> Hue,Mesh -> mesh, MeshStyle -> Directive[White]]
    ]

plotHeatMap[inputpairwisedata_?(ListQ[#] || StringQ[#] &), mapfile_String?FileExistsQ, opts : OptionsPattern[]] :=
    Module[ {pairwisedata = inputpairwisedata,chrsubset,map,index, lodtype, isfounderinbred, 
      minlodsaving, morganrate, snpid, rfmtx, linklodmtx, indeplodmtx, 
      order, mtxls, labells, res, isreverse, lab},
        chrsubset = OptionValue[linkageGroupSet];
        If[ StringQ[pairwisedata],
            If[ ! FileExistsQ[pairwisedata],
                Print["File ", pairwisedata, " does not exist!"];
                Return[$Failed]
            ];
            pairwisedata = readPairwiseDatafile[pairwisedata];
        ];
        {lodtype, isfounderinbred, minlodsaving, morganrate, snpid, rfmtx, linklodmtx, indeplodmtx} = pairwisedata;
        map = Import[mapfile, Path -> Directory[]];
        If[ ! (SubsetQ[map[[2 ;;, 1]], snpid] &&SubsetQ[snpid, map[[2 ;;, 1]]]),
            Print["Inconsistent marker id!"];
        ];
        map = SplitBy[map[[2 ;;, ;; 2]], Last][[All, All, 1]];
        map = map[[chrsubset]];
        index = Sort[Flatten[map] /. Thread[snpid -> Range[Length[snpid]]]];
        snpid = snpid[[index]];
        {rfmtx, linklodmtx, indeplodmtx} = If[ MissingQ[#],
                                               #,
                                               #[[index, index]]
                                           ] & /@ {rfmtx, linklodmtx,indeplodmtx};
        order = map /. Thread[snpid -> Range[Length[snpid]]];
        rfmtx = Max[rfmtx]-rfmtx;
        linklodmtx = Log[1 + ReplacePart[linklodmtx, {i_, i_} :> 0]];
        indeplodmtx = Log[1 + ReplacePart[indeplodmtx, {i_, i_} :> 0]];
        Switch[ToLowerCase[lodtype],
         "both",
         mtxls = {rfmtx, linklodmtx, indeplodmtx};
         labells = {"Recombination fraction", "Linkage LOD", "Independence LOD"},
         "linkage",
         mtxls = {rfmtx, linklodmtx};
         labells = {"Recombination fraction", "Linkage LOD"},
         "independence",
         mtxls = {indeplodmtx};
         labells = {"Independence LOD"},
         _,
         Print[];
         Abort[];
         ];
        {isreverse} = OptionValue@{DataReversed};
        res = MapThread[plotHeatMap[#1, order, opts, DataReversed -> isreverse, 
            ColorFunctionScaling -> False, PlotLabel -> #2] &, {mtxls,labells}];
        If[ MemberQ[{"both", "linkage"}, ToLowerCase[lodtype]],
            lab = If[ isreverse,
                      "Recombination fraction / Linkage LOD",
                      "Linkage LOD \\ Recombination fraction "
                  ];
            AppendTo[res, plotHeatMap[mtxls[[1]], mtxls[[2]], order, opts, 
              DataReversed -> isreverse, ColorFunctionScaling -> False, PlotLabel -> lab]];
        ];
        If[ MemberQ[{"both"}, ToLowerCase[lodtype]],
            lab = If[ isreverse,
                      "Linkage LOD / Independence LOD",
                      "Independence LOD \\ Linkage LOD"
                  ];
            AppendTo[res, plotHeatMap[mtxls[[2]], mtxls[[3]], order, opts, 
              DataReversed -> isreverse, ColorFunctionScaling -> False,PlotLabel -> lab]];
        ];
        res
    ]

Options[plotHeatMapGUI] = Options[plotHeatMap]

plotHeatMapGUI[pairwisedatafile_String?FileExistsQ, mapfile_String?FileExistsQ, opts : OptionsPattern[]] :=
    Module[ {pairwisedata,groupset, ggls, labls},
        pairwisedata = readPairwiseDatafile[pairwisedatafile];
        groupset = Import[mapfile, Path -> Directory[]];
        groupset = Length[Union[groupset[[2 ;;, 2]]]];
        groupset = Subsets[Range[groupset], 2];
        groupset = ReplacePart[groupset, 1 -> All];
        Manipulate[
         ggls = plotHeatMap[pairwisedata, mapfile, opts, linkageGroupSet->set,
           rescaleSimilarity -> isrescale, PlotLegends -> Automatic, 
           DataReversed -> isreverse, ColorFunctionScaling -> isscale, 
           ColorFunction -> color, ImageSize -> size];
         labls = Switch[Length[ggls],
           1, {"Independence LOD"},
           3, {"Recombination fraction", "Linkage LOD", "Recombination fraction & Linkage LOD"},
           5, {"Recombination fraction", "Linkage LOD", "Independence LOD", 
            "Recombination fraction & Linkage LOD", "Linkage LOD & Independence LOD"},
           _, Abort[];
           ];
         TabView[Thread[labls -> ggls], Min[Length[ggls], 4]], 
         Row[{Control[{{set, All, "LinkageGroups"},groupset}], 
           Control[{{isrescale, True, "DataRescale"}, {True, False}}], 
           Control[{{isreverse, True, "DataReversed"}, {True, False}}], 
           Control[{{size, 800, "ImageSize"}, 200, 2000, 100}]}, Spacer[10]],
         Row[{Control[{{isscale, False, "ColorFunctionScaling"}, {True, False}}], 
           Control[{{color, Hue, "ColorScheme"}, {Hue, "TemperatureMap","Rainbow", "SunsetColors", "GreenPinkTones"}}]}, Spacer[10]],
         ContinuousAction -> False
         ]
    ]
  
End[] (* End Private Context *)

EndPackage[]