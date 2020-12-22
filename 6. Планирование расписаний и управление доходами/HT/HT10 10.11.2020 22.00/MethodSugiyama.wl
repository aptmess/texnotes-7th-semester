(* ::Package:: *)

BeginPackage["MethodSugiyama`"]


GetGraph::usage="getGraph[\!\(\*
StyleBox[\"v\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] \:0433\:0435\:043d\:0435\:0440\:0438\:0440\:0443\:0435\:0442 \:0433\:0440\:0430\:0444 \:0441 \:043a\:043e\:043b\:0438\:0447\:0435\:0441\:0442\:0432\:043e\:043c \:0432\:0435\:0440\:0448\:0438\:043d \!\(\*
StyleBox[\"v\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\) \:0438 \:043f\:043b\:043e\:0442\:043d\:043e\:0441\:0442\:044c\:044e \:0433\:0440\:0430\:0444\:0430 0.3.\n\ngetGraph[\!\(\*
StyleBox[\"v,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"density\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] \:0433\:0435\:043d\:0435\:0440\:0438\:0440\:0443\:0435\:0442 \:0433\:0440\:0430\:0444 \:0441 \:043a\:043e\:043b\:0438\:0447\:0435\:0441\:0442\:0432\:043e\:043c \:0432\:0435\:0440\:0448\:0438\:043d \!\(\*
StyleBox[\"v\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\) \:0438 \:043f\:043b\:043e\:0442\:043d\:043e\:0441\:0442\:044c\:044e \:0433\:0440\:0430\:0444\:0430 \!\(\*
StyleBox[\"density\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\).";


GetDAG::usage="getDAG[\!\(\*
StyleBox[\"graph,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"opts\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] \:043d\:0430\:0445\:043e\:0434\:0438\:0442 \:0430\:0446\:0438\:043a\:043b\:0438\:0447\:043d\:044b\:0439 \:043f\:043e\:0434\:0433\:0440\:0430\:0444 \:0433\:0440\:0430\:0444\:0430 \!\(\*
StyleBox[\"graph\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\) \:0438 \:0434\:043e\:043f\:043e\:043b\:043d\:0438\:0442\:0435\:043b\:044c\:043d\:044b\:043c\:0438 \:043d\:0430\:0441\:0442\:0440\:043e\:0439\:043a\:0430\:043c\:0438 \:0444\:0443\:043d\:043a\:0446\:0438\:0438 \!\(\*
StyleBox[\"opts\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\).";


GetDAG::"Graph"="\:0410\:0440\:0433\:0443\:043c\:0435\:043d\:0442 graph \:0434\:043e\:043b\:0436\:0435\:043d \:0431\:044b\:0442\:044c \:0437\:0430\:0434\:0430\:043d \:043a\:0430\:043a \:043e\:0431\:044a\:0435\:043a\:0442 \:0442\:0438\:043f\:0430 Graph.";


GetDAG::option="Option `1` is not in list of options. Choose another one from the list: \n`2`";


GetDAG::RESoption="Option `1` is not in list of ResOptions. Choose another one from the list: \n`2`";


GetLayering::option = "Option `1` is not in list of options. Choose another one from the list: \n`2`";


AddDummyVertices::option = "Option `1` is not in list of options. Choose another one from the list: \n`2`";


GetVertexOrder::option = "Option `1` is not in list of options. Choose another one from the list: \n`2`";


getOrderRandom;(*Random Order*)
BFSearch;(*BFS Order*)
DFSearch;(*DFS Order*)
DDVertex;(*VertexOutDegreeOrder*)
GreedyCycleRemoval;(*Cycle Removal*)
SetCoveringFormulation;(*IP SCF*)
getAcyclicTriangle;(*IP TI*)


Begin["`Private`"]


Attributes[GetGraph]={ReadProtected};
GetGraph[v_,density_:0.3]:=
	Module[
			{
				e = Round[
						Solve[x/(v(v-1)) == density,x][[1,1,2]]
					],
				vertices = Range@v,
				connectedpart,
				cycle,
				base,
				additionaledges = {}
			},
				connectedpart = If[#[[2]]==0,#[[1]],Reverse@#[[1]]]&/@
					MapThread[
						Rule,
						{
							Partition[RandomSample[vertices],2,1],
							RandomInteger[{0,1},v-1]
						}
					];
				cycle = Append[#,{#[[-1,-1]],#[[1,1]]}]&@
							Partition[
								RandomSample[
									vertices,
									RandomInteger[{3,v-1}]
								],
							2,1];
				base = Union[connectedpart,cycle];
				If[
					e <= Length@base,
					Nothing,
					additionaledges = Table[RandomSample[vertices,2],e-Length@base]
				];
				Graph[DirectedEdge@@@Union[base,additionaledges]]
	]


getOrderRandom[graph_]:=RandomSample@VertexList[graph]


Clear[DFSearch]; 
DFSearch[G_?GraphQ]:=Reap[DepthFirstScan[G,{"DiscoverVertex"->(Sow[#]&)}]][[-1]][[1]];


Clear[BFSearch];
BFSearch[G_?GraphQ]:=DeleteDuplicates[Reap[BreadthFirstScan[G,{"DiscoverVertex"->(Sow[#]&)}]][[-1]][[1]]];


Clear[DDVertex];
DDVertex[G_?GraphQ]:=Keys[ReverseSort[Association[Thread[VertexList[G]->VertexOutDegree[G]]]]]


sinkV[g_?GraphQ]:=Pick[VertexList[g],VertexOutDegree[g],False]


sourceV[g_?GraphQ]:=Pick[VertexList[g],VertexInDegree[g],False]


acANDfs[G_?GraphQ,sort_]:=Module[{e=EdgeList[G],sortV = sort[G],mask,ACyG,FS},
mask = Table[MatchQ[sortV ,{___,edg[[1]],___,edg[[2]],___}],{edg,e}];(*\:043f\:0440\:043e\:0432\:0435\:0440\:044f\:0435\:043c, \:043b\:0435\:0432\:0435\:0435 \:043b\:0438 \:0440\:043e\:0434\:0438\:0442\:0435\:043b\:044c \:043f\:043e\:0442\:043e\:043c\:043a\:0430 \:043f\:043e \:0441\:043e\:043e\:0442\:0432\:0435\:0441\:0442\:0432\:0435\:043d\:043d\:043e\:0439 \:0441\:043e\:0440\:0442\:0438\:0440\:043e\:0432\:043a\:0435*)
ACyG = Pick[e,mask,True];
FS= Pick[e,mask,False];
<|"acyclic graph"->ACyG, "feedback set"->FS|>
]


GreedyCycleRemoval[g_?GraphQ]:=
Module[{sl={},sr={},G=g,sinks,sources,w},
While[
EmptyGraphQ[G]==False,
sinks=sinkV[G];
While[sinks!={},
	G=VertexDelete[G,sinks];
	PrependTo[sr,sinks];
	sinks=sinkV[G];
	];
sources=sourceV[G];
While[sources!={},
	G=VertexDelete[G,sources];
	AppendTo[sl,sources];
	sources=sourceV[G];
	];
If[EmptyGraphQ[G]==False,
	w =First[Keys[ReverseSort[Association[Thread[VertexList[G]->Table[VertexOutDegree[G,v]-VertexInDegree[G,v],{v,VertexList[G]}]]]]]];
	G=VertexDelete[G,w];
	AppendTo[sl,w];
	]
	];
Flatten[sl]~Join~Flatten[sr]
]


SetCoveringFormulation[g_?GraphQ,W_]:=Module[{cycles,A,M,a,vars,objfun,c,b,domain,lu,solution,setCoveringFormulationSolution,ACyG, FS},
cycles=FindCycle[g,Infinity,All];
A=EdgeList[g];
M=SparseArray@Table[a=ConstantArray[0,Length[A]];a[[EdgeIndex[g,c]]]=1;a,{c,cycles}];
vars=y/@EdgeList[g];
objfun=Total[vars*W];
c=Last[CoefficientArrays[objfun,vars]];
b=ConstantArray[{1,1},Length@cycles];
domain=ConstantArray[Integers,Length[vars]];
lu=ConstantArray[{0,1},Length[vars]];
solution=Quiet[LinearProgramming[c, M, b, lu, domain]];
ACyG=Pick[A,solution,0];
FS=Pick[A,solution,1]; <|"acyclic graph"->ACyG, "feedback set"->FS|>]


getAcyclicTriangle[G_?GraphQ]:=Module[{vertices=VertexList[G],arcs=List@@@EdgeList[G],varsX,pair,of,x,step1,con1,rhs1,getVector,sol,mask,order,ACyG,FS,n},varsX=x@@@Subsets[vertices,{2}];
n=Length@vertices;
of=Total[arcs/.{{i_Integer,j_}/;i<j:>-x[i,j],{i_Integer,j_}:>x[j,i]}];
step1=Flatten@Table[x[i,j]+x[j,k]-x[i,k],{i,n-2},{j,i+1,n-1},{k,j+1,n}];con1=Join[step1,step1];
rhs1=Join[ConstantArray[{1,-1},Length@step1],ConstantArray[{0,1},Length@step1]];
getVector=Last[CoefficientArrays[#,varsX]]&;
sol=Quiet[LinearProgramming[getVector@of,getVector@con1,rhs1,ConstantArray[{0,1},Length@varsX],Integers]];
mask=ConstantArray[0,n];
Do[If[pair[[2]]==1,mask[[pair[[1,2]]]]++,mask[[pair[[1,1]]]]++],{pair,Transpose[{varsX,sol}]}];
order=Ordering@mask;
ACyG=Select[EdgeList[G],MatchQ[order,{___,#[[1]],___,#[[2]],___}]&];
FS=Complement[EdgeList[G],ACyG];
<|"acyclic graph"->ACyG, "feedback set"->FS|>
]


Options[GetDAG]={ApproachOption->"Random order", ResultOption->"full"};
GetDAG[graph_,OptionsPattern[]]:=
(
	Check[
		If[
			!GraphQ[graph]
			,Message[GetDAG::"Graph"]
		],
		Abort[]
	];
	Module[
		{
			result,
			opt={"Random order","BFS order","DFS Order","VertexOutDegree Order","Cycle Removal","IP SCF","IP TI"},
			resoption={"full","acyclic graph","feedback set"},
			approach=OptionValue[ApproachOption],
			resOption=OptionValue[ResultOption]
		},
		If[MemberQ[opt,approach],
		Which[
		approach==="Random order", result = acANDfs[graph,getOrderRandom],
		approach==="BFS order", result = acANDfs[graph,BFSearch],
		approach==="DFS Order", result = acANDfs[graph,DFSearch],
		approach==="VertexOutDegree Order", result = acANDfs[graph,DDVertex],
		approach==="Cycle Removal", result = acANDfs[graph,GreedyCycleRemoval],
		approach==="IP SCF", result = SetCoveringFormulation[graph,ConstantArray[1,Length[EdgeList[graph]]]],
		approach==="IP TI", result = getAcyclicTriangle[graph]
		], Message[GetDAG::option,approach, StringRiffle[opt, "\n","\t"]]; Abort[]];
		If[MemberQ[resoption,resOption],
		Which[resOption==="full",result,
		resOption==="acyclic graph",result["acyclic graph"],resOption==="feedback set",result["feedback set"]],
		Message[GetDAG::RESoption,resOption, StringRiffle[resoption, "\n","\t"]]; Abort[]]
	]
)


LayeringLongestPath[getDagResult_]:=Module[{g=Graph[Union[getDagResult["acyclic graph"],Reverse/@getDagResult["feedback set"]],VertexLabels->"Name"],U={},Z={},L={},currentLayer=1,V,relations,v,dop,mask},
V=Sort@VertexList[g];
relations=Association[Table[v-><|"\:0440\:0435\:0431\:0435\:043d\:043e\:043a \:0434\:043b\:044f \:0432\:0435\:0440\:0448\:0438\:043d"->Cases[IncidenceList[g,v],e_\[DirectedEdge]h_/;h==v->e],
"\:0440\:043e\:0434\:0438\:0442\:0435\:043b\:044c \:0434\:043b\:044f \:0432\:0435\:0440\:0448\:0438\:043d"->Cases[IncidenceList[g,v],e_\[DirectedEdge]h_/;e==v->h]|>,{v,V}]];
While[
!Union[U]===V(*\:043f\:043e\:043a\:0430 \:043d\:0435 \:043e\:0431\:043e\:0439\:0434\:0435\:043c \:0432\:0441\:0435 \:0432\:0435\:0440\:0448\:0438\:043d\:044b*),
dop=Complement[V,U];(*\:0440\:0430\:0437\:043d\:043e\:0441\:0442\:044c \:043c\:043d\:043e\:0436\:0435\:0441\:0442\:0432 V \ U*)
mask=Table[SubsetQ[Z,relations[i]["\:0440\:0435\:0431\:0435\:043d\:043e\:043a \:0434\:043b\:044f \:0432\:0435\:0440\:0448\:0438\:043d"]],{i,dop}];
v=Pick[dop,mask,True];(*\:0440\:0430\:0441\:0441\:043c\:0430\:0442\:0440\:0438\:0432\:0430\:0435\:043c \:0432\:0435\:0440\:0448\:0438\:043d\:044b, \:0443 \:043a\:043e\:0442\:043e\:0440\:044b\:0445 \:0432\:0441\:0435 \:0432\:0441\:0435 \:0434\:0435\:0442\:0438 \:043b\:0435\:0436\:0430\:0442 \:0432 \:043c\:043d\:043e\:0436\:0435\:0441\:0442\:0432\:0435 Z*)
Which[v!={},(*v has been selected - \:0435\:0441\:043b\:0438 \:0432\:0435\:0440\:0448\:0438\:043d\:044b \:0441\:0443\:0449\:0435\:0441\:0442\:0432\:0443\:044e\:0442, \:0442\:043e \:0432\:043e\:0437\:044c\:043c\:0435\:043c \:043f\:0435\:0440\:0432\:0443\:044e*)
AppendTo[L,{currentLayer,First[v]}];(*\:0434\:043e\:0431\:0430\:0432\:043b\:044f\:0435\:043c \:0432\:0435\:0440\:0448\:043d\:0438\:043d\:0443 \:043d\:0430 \:0441\:043b\:043e\:0439 currentLayer*)
AppendTo[U,First[v]],
v=={},(*no vertext has been selected*)
currentLayer=currentLayer+1;
Z=Z\[Union]U];
];
<|"acyclic graph"->getDagResult["acyclic graph"], "feedback set"->getDagResult["feedback set"],"layers"->GatherBy[L,First][[All,All,2]]|>

]


LayeringExact[getDagResult_]:=Module[{g=Graph[Union[getDagResult["acyclic graph"],Reverse/@getDagResult["feedback set"]],VertexLabels->"Name"],A=Union[getDagResult["acyclic graph"],Reverse/@getDagResult["feedback set"]],V,\[Lambda]vars,cond1,objfun,c,m,b,lu,domain,solution,l,\[Lambda]},
V=Sort@VertexList@g;
\[Lambda]vars=\[Lambda]/@V;
cond1=Cases[A,in_\[DirectedEdge]two_:>\[Lambda][two]-\[Lambda][in]];
objfun=Total@cond1;
c=Last@CoefficientArrays[objfun,\[Lambda]vars];
m=Last@CoefficientArrays[cond1,\[Lambda]vars];
b=ConstantArray[{1,1},Length[A]];
lu=ConstantArray[{0,Infinity},Length[\[Lambda]vars]];
domain=ConstantArray[Reals,Length[\[Lambda]vars]];
solution=Quiet[LinearProgramming[c,m,b,lu,domain]];
l=SortBy[GatherBy[Thread[{V,solution}],Last],#[[1,2]]&][[All,All,1]];
<|"acyclic graph"->getDagResult["acyclic graph"], "feedback set"->getDagResult["feedback set"],"layers"->l|>
]


Clear[PromoteVertex,VertexPromotionHeuristic,ImproveHeuristic]
PromoteVertex[v_]:=Module[{dummydiff=0,b=relations[v]["parents"]},
s=Table[If[layer[u]==layer[v]+1,
		dummydiff=dummydiff+PromoteVertex[u]],
{u,b}];
layer[v]=layer[v]-1;
dummydiff=dummydiff-Length[relations[v]["parents"]]+Length[relations[v]["children"]];
dummydiff]

VertexPromotionHeuristic[]:=Module[{layeringBackUp=layer, promotions=0},
While[promotions==0,
s=Table[
	If[Length[relations[v]["parents"]]>0,
		If[PromoteVertex[v]<0,
			promotions=promotions+1;
			layeringBackUp=layer,
		layer=layeringBackUp]],
{v,V}];
];layer]

ImproveHeuristic[DAG_]:=Module[{g=Graph[Union[DAG["acyclic graph"],Reverse/@DAG["feedback set"]],VertexLabels->"Name"],
newnames,resultLayer,betterlayers},
V = Flatten[DAG["layers"]];
relations=Association[Table[v-><|"parents"->Cases[IncidenceList[g,v],e_\[DirectedEdge]h_/;h==v->e],
"children"->Cases[IncidenceList[g,v],e_\[DirectedEdge]h_/;e==v->h]|>,{v,V}]];
newnames=MapIndexed[v[#2[[1]],#1]&,DAG["layers"],{2}];
layer=Association[Thread[Flatten@DAG["layers"]->Flatten[newnames][[All,1]]]];
resultLayer=VertexPromotionHeuristic[];betterlayers=GatherBy[Normal[resultLayer],Last][[All,All,1]];
<|"acyclic graph"->DAG["acyclic graph"],"feedback set"->DAG["feedback set"],"layers"->betterlayers|>]


Clear[MinWidthHeuristic]
MinWidthHeuristic[getDagResult_,W_:20,c_:1]:=Module[{dag=Graph[Union[getDagResult["acyclic graph"],Reverse/@getDagResult["feedback set"]],VertexLabels->"Name"],
U={},
Z={},
currentLayer=1,
widthCurrent=0,
widthUp=0,
newlayers={},
l,step1,step2},
verticesList=Sort@VertexList[dag];edgesList=EdgeList[dag];adjAssoc=Association@Table[v-><|"parents"-> Select[edgesList,#[[2]]==v&][[All,1]],"children"-> Select[edgesList,#[[1]]==v&][[All,2]]|>,{v,verticesList}];
While[
!ContainsExactly[verticesList,U],
step1=Select[Complement[verticesList,U],SubsetQ[Z,adjAssoc[#]["children"]]&];
If[step1!={},
step2=Table[VertexOutDegree[dag, ve],{ve,step1}];
v=step1[[First[Flatten[Position[step2,Max[step2]]]]]],v=0];(*\:0432\:0435\:0440\:0448\:0438\:043d\:0430 \:0441 \:043c\:0430\:043a\:0441\:0438\:043c\:0430\:043b\:044c\:043d\:044b\:043c \:043a\:043e\:043b\:0438\:0447\:0435\:0441\:0442\:0432\:043e OutDegree*)
If[
v!=0,
AppendTo[newlayers,{currentLayer,v}];
AppendTo[U,v];
widthCurrent=widthCurrent-VertexOutDegree[dag, v]+1;widthUp=widthUp+VertexInDegree[dag, v]];
If[(v==0)||((widthCurrent>=W )&&(VertexOutDegree[dag, v]==0))||(widthUp>=c*W),
currentLayer++;
Z=Union[Z,U];
widthCurrent=widthUp;
widthUp=0
]
];l=GatherBy[newlayers,First][[All,All,2]];
<|"acyclic graph"->getDagResult["acyclic graph"], "feedback set"->getDagResult["feedback set"],"layers"->l|>]


Options[GetLayering]={ApproachOption->"Longest Path", ImprovmentOption->False};
GetLayering[DagResult_,OptionsPattern[]]:=
(
	Module[
		{
			result,
			options={"Longest Path", "Exact", "Min Width"},
			improveoptions={True,False},
			approach=OptionValue[ApproachOption],
			improveOpt=OptionValue[ImprovmentOption],m
		},
		m=MatchQ[approach,{"Min Width",_?IntegerQ,_?IntegerQ}];
		If[(MemberQ[options,approach]) || m ==True,
		Which[
			approach==="Longest Path", result = LayeringLongestPath[DagResult],
			approach==="Exact", result = LayeringExact[DagResult],
			approach==="Min Width",result = MinWidthHeuristic[DagResult],
			m===True, result=MinWidthHeuristic[DagResult,approach[[2]],approach[[3]]]
		], 
		Message[GetLayering::option, approach, StringRiffle[options, "\n","\t"]]; Abort[]];
		If[MemberQ[improveoptions,improveOpt],
		If[improveOpt==True,result=ImproveHeuristic[result]],
		Message[GetLayering::option, improveOpt, StringRiffle[improveoptions, "\n","\t"]]; Abort[]];
		result
	]
)


Clear[unionDAGandFSInAcycicGraph]
unionDAGandFSInAcycicGraph[result_Association]:=Graph[DeleteDuplicates@Join[result["acyclic graph"],Reverse/@result["feedback set"]],VertexLabels->"Name"]


Clear[GetBaseDummyVertices]
GetBaseDummyVertices[GetLayeringRes_]:=Module[{dag=unionDAGandFSInAcycicGraph[GetLayeringRes],newnames,rules,arcsWithLongConnections,start,dummynum,longArcs,forAdd,parent, child, startLayer, dummyVertices,arcsWithoutLongConnections,layersWithDummyVertices,arcsWithDummyVertices},
newnames=MapIndexed[v[#2[[1]],#1]&,GetLayeringRes["layers"],{2}];rules=MapThread[Rule,{Flatten@GetLayeringRes["layers"],Flatten@newnames}];arcsWithLongConnections=EdgeList@dag/.rules;start=dummynum=Max[VertexList@dag]+1;
longArcs=Select[arcsWithLongConnections,#[[2,1]]-#[[1,1]]>1&];
forAdd={};
Do[
{parent,child}=List@@longEdge;
startLayer=parent[[1]]+1;

dummyVertices=Table[v[layer,dummynum++],{layer,Range[startLayer,child[[1]]-1]}];

forAdd=Join[
forAdd,
DirectedEdge@@@
Partition[
{parent}~Join~dummyVertices~Join~{child},
2,1
]
],
{longEdge,longArcs}
];
arcsWithoutLongConnections=Join[DeleteCases[arcsWithLongConnections,Alternatives@@longArcs],forAdd];
layersWithDummyVertices=SortBy[GatherBy[VertexList@arcsWithoutLongConnections,First],#[[1,1]]&][[All,All,2]];
arcsWithDummyVertices=arcsWithoutLongConnections[[All,All,2]];
<|"acyclic graph"->GetLayeringRes["acyclic graph"], 
"feedback set"->GetLayeringRes["feedback set"],
"graph with dummies"->arcsWithDummyVertices,
"layers with dummies"->layersWithDummyVertices,
"first dummy"->start|>
]


Clear[GetCutDummyVertices]
GetCutDummyVertices[GetLayeringRes_]:=Module[{dag=unionDAGandFSInAcycicGraph[GetLayeringRes],newnames,rules,arcsWithLongConnections,start,dummynum,longArcs,forAdd,parent, child, startLayer, dummyVertices,arcsWithoutLongConnections,layersWithDummyVertices,arcsWithDummyVertices,step0,step1,step2,step3,step4,step5,adjchilden,assAdjChildern},
newnames=MapIndexed[v[#2[[1]],#1]&,GetLayeringRes["layers"],{2}];rules=MapThread[Rule,{Flatten@GetLayeringRes["layers"],Flatten@newnames}];arcsWithLongConnections=EdgeList@dag/.rules;start=dummynum=Max[VertexList@dag]+1;
longArcs=Select[arcsWithLongConnections,#[[2,1]]-#[[1,1]]>1&];
step0=Select[Tally[longArcs[[All,2]]],#[[2]]>1&][[All,1]];
step1=Select[longArcs,MemberQ[step0,#[[2]]]&];
step2=GatherBy[Cases[step1,v[i_,j_]\[DirectedEdge]v[k_,l_]->v[k,l]\[DirectedEdge]v[i,j]],First];
step3=step2[[All,All,2]];
step4=Thread[Range[Length[step3]]->step3];
step5=Select[step4,#[[2,1,1]]==#[[2,2,1]]&];
adjchilden=step0[[step5[[All,1]]]];(*\:0432\:0441\:0435 \:0432\:044b\:0448\:0435 \:0432\:0435\:0434\:0435\:0442\:0441\:044f \:0438\:043c\:0435\:043d\:043d\:043e \:043a \:044d\:0442\:043e\:043c\:0443 \:0448\:0430\:0433\:0443 - \:043d\:0430\:0439\:0442\:0438 \:0441\:043c\:0435\:0436\:043d\:044b\:0435 \:0432\:0435\:0440\:0448\:0438\:043d\:044b \:0434\:043b\:044f \:0432\:0435\:0440\:0448\:0438\:043d, \:043b\:0435\:0436\:0430\:0449\:0438\:0445 \:043d\:0430 \:043e\:0434\:043d\:043e\:043c \:0443\:0440\:043e\:0432\:043d\:0435 \:0438 \:043f\:0440\:0438 \:044d\:0442\:043e\:043c level[child] - level[parent]>1*)
assAdjChildern=<||>;
forAdd={};
Do[
{parent,child}=List@@longEdge;
startLayer=parent[[1]]+1;

dummyVertices=Table[If[MemberQ[adjchilden,child],
If[MemberQ[Keys[assAdjChildern],child],If[dummynum==assAdjChildern[child][[1]]+layer-assAdjChildern[child][[2]],dummynum++];
v[layer,assAdjChildern[child][[1]]+layer-assAdjChildern[child][[2]]],
assAdjChildern[child]={dummynum++,layer};
v[layer,assAdjChildern[child][[1]]]],
v[layer,dummynum++]],
{layer,Range[startLayer,child[[1]]-1]}];
forAdd=Join[
forAdd,
DirectedEdge@@@
Partition[
{parent}~Join~dummyVertices~Join~{child},
2,1
]
],
{longEdge,longArcs}
];
arcsWithoutLongConnections=Join[DeleteCases[arcsWithLongConnections,Alternatives@@longArcs],forAdd];
layersWithDummyVertices=SortBy[GatherBy[VertexList@arcsWithoutLongConnections,First],#[[1,1]]&][[All,All,2]];
arcsWithDummyVertices=Select[DeleteDuplicates[arcsWithoutLongConnections[[All,All,2]]],#[[1]]!=#[[2]]&];
<|"acyclic graph"->GetLayeringRes["acyclic graph"], 
"feedback set"->GetLayeringRes["feedback set"],
"graph with dummies"->arcsWithDummyVertices,
"layers with dummies"->layersWithDummyVertices,
"first dummy"->start|>
]


Options[AddDummyVertices]={ApproachOption->"Cut"};
AddDummyVertices[gLayerRes_,OptionsPattern[]]:=
(
	Module[
		{
			result,
			options={"Base", "Cut"},
			approach=OptionValue[ApproachOption]
		},
		If[MemberQ[options,approach],
		Which[
			approach==="Base", result = GetBaseDummyVertices[gLayerRes],
			approach==="Cut", result = GetCutDummyVertices[gLayerRes]
		], 
		Message[AddDummyVertices::option, approach, StringRiffle[options, "\n","\t"]]; Abort[]];
		result
	]
)


Clear[isPairOfEdgesCrossing]
isPairOfEdgesCrossing[{edge1_,edge2_},ordering_]:=
	If[
			edge1[[1]] === edge2[[1]] || edge1[[2]] === edge2[[2]],
			0,
			Boole[
				Xor[
					FirstPosition[ordering,edge1[[1]]][[2]] < FirstPosition[ordering,edge2[[1]]][[2]],
					FirstPosition[ordering,edge1[[2]]][[2]] < FirstPosition[ordering,edge2[[2]]][[2]]
				]
			]
			
		]
Clear[getNumberOfCrossings]
getNumberOfCrossings[arcs_,order_]:=Total[isPairOfEdgesCrossing[#,order]&/@Subsets[arcs,{2}]]


Clear[getBarycenterValueExample]
getBarycenterValueExample[vertixID_,order_,adj_]:=
	Module[
		{
			list = SelectFirst[adj,#[[1]]==vertixID&,{}]
		},
		If[
			Length[list]==0,
			-1,
			N@Mean[Position[order,#][[1,1]]&/@list[[2]]]
		]
	]


Clear[getBarycenterSortForTwoLayers]
getBarycenterSortForTwoLayers[order_, arcs_, adjLists_, first_, second_]:=Module[
{bc, sortV, m,step1,step2,step3},
bc= {#, getBarycenterValueExample[#, order[[second]], adjLists]}&/@ order[[first]];
step1 = GatherBy[DeleteCases[bc, {_,-1}], Last];
step2 = SortBy[step1, #[[1,2]]&];
sortV= Flatten[step2[[All,All,1]]];
m = (bc/.{{_, a_}/; a!=-1 -> {Missing[]}})[[All,1]];
Do[If[MissingQ[m[[i]]],
m[[i]]=First[sortV]; 
sortV=Rest[sortV]],
{i,Length[m]}];
ReplacePart[order, first-> m]]


ClearAll[getVertexOrderBarycenter]
getVertexOrderBarycenter[gDummiesRes_,layers_, arcs_, amountOFiterations_] :=
Module[{order = layers,adjLists,adjListsReverse ,resultOrder,crossers,n=Length[layers],bestresults = {},
step1={#[[1,2]], #[[All,1]]} & /@ SortBy[GatherBy[arcs, Last], #[[1,2]] &],
step2={#[[1,2]], #[[All,1]]} & /@ SortBy[GatherBy[Reverse /@ arcs, Last], #[[1,2]] &],
pairsOfEdges = Flatten[Subsets[#, {2}] & /@ GatherBy[arcs, #[[1, 1]] &], 1]},
adjLists = Thread[GatherBy[step1 ,#[[1, 1]]&][[All,1,1,1]] -> GatherBy[step1 ,#[[1, 1]] &]];
adjListsReverse =Thread[GatherBy[step2,#[[1, 1]]&][[All,1,1,1]] -> GatherBy[step2 ,#[[1, 1]] &]];
crossers=Total[isPairOfEdgesCrossing[#, order] & /@ pairsOfEdges];
Do[
	If[Mod[iter, 2] != 0,
		Do[order[[{i, i+1}]] = getBarycenterSortForTwoLayers[order[[{i, i+1}]], 
				Select[arcs, #[[1, 1]] == i &], i+1 /. adjLists, 2, 1], {i, n-1}],
		Do[order[[{i-1, i}]] = getBarycenterSortForTwoLayers[order[[{i-1, i}]], 
				Select[arcs, #[[1, 1]] == i-1 &], i-1/.adjListsReverse, 1, 2], {i, n, 2, -1}]];AppendTo[bestresults, {order, crossers}],
{iter,amountOFiterations}
];
resultOrder=MinimalBy[bestresults,Last][[1,1]];
<|"acyclic graph"->gDummiesRes["acyclic graph"], 
"feedback set"->gDummiesRes["feedback set"],
"graph with dummies"->gDummiesRes["graph with dummies"],
"layers with dummies"->resultOrder[[All,All,2]],
"first dummy"->gDummiesRes["first dummy"]|>
]


Options[GetVertexOrder]={ApproachOption->"barycenter"};
GetVertexOrder[gDummiesRes_,OptionsPattern[]]:=
(
	Module[
		{
			result, l, layers,rules,edges,y,arcs,
			options={"barycenter"},
			approach=OptionValue[ApproachOption]
		},
		l=gDummiesRes["layers with dummies"];
		layers=MapIndexed[v[#2[[1]],#1]&,l,{2}];
		rules=MapThread[Rule,{Flatten@l,Flatten@layers}];
		edges=gDummiesRes["graph with dummies"];
		y=EdgeList@edges/.rules;
		arcs=Cases[y,v[e_,a_]\[DirectedEdge]v[b_,c_]->{v[e,a],v[b,c]}];
		If[MemberQ[options,approach],
		Which[
			approach==="barycenter", result = getVertexOrderBarycenter[gDummiesRes, layers, arcs, 20]
		], 
		Message[GetVertexOrder::option, approach, StringRiffle[options, "\n","\t"]]; Abort[]];
		result
	]
)


End[]


EndPackage[]
