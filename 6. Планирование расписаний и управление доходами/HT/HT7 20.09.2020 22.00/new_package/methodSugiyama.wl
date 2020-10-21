(* ::Package:: *)

BeginPackage["methodSugiyama`"]


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


LayeringLongestPath[getDagResult_]:=Module[{g=Graph[getDagResult["acyclic graph"],VertexLabels->"Name"],U={},Z={},L={},currentLayer=1,V,relations,v,dop,mask},
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


LayeringExact[getDagResult_]:=Module[{g=Graph[getDagResult["acyclic graph"],VertexLabels->"Name"],A=getDagResult["acyclic graph"],V,\[Lambda]vars,cond1,objfun,c,m,b,lu,domain,solution,l,\[Lambda]},
V=Sort@VertexList@g;
\[Lambda]vars=\[Lambda]/@V;
cond1=Cases[A,in_\[DirectedEdge]two_-> \[Lambda][two]-\[Lambda][in]];
objfun=Total@cond1;
c=Last@CoefficientArrays[objfun,\[Lambda]vars];
m=Last@CoefficientArrays[cond1,\[Lambda]vars];
b=ConstantArray[{1,1},Length[A]];
lu=ConstantArray[{0,Infinity},Length[\[Lambda]vars]];
domain=ConstantArray[Integers,Length[\[Lambda]vars]];
solution=Quiet[LinearProgramming[c,m,b,lu,domain]];
l=SortBy[GatherBy[Thread[{V,solution}],Last],#[[1,2]]&][[All,All,1]];
<|"acyclic graph"->getDagResult["acyclic graph"], "feedback set"->getDagResult["feedback set"],"layers"->l|>
]


Options[GetLayering]={ApproachOption->"Longest Path"};
GetLayering[DagResult_,OptionsPattern[]]:=
(
	Module[
		{
			result,
			options={"Longest Path", "Exact"},
			approach=OptionValue[ApproachOption]
		},
		If[MemberQ[options,approach],
		Which[
			approach==="Longest Path", result = LayeringLongestPath[DagResult],
			approach==="Exact", result = LayeringExact[DagResult]
		], 
		Message[GetLayering::option, approach, StringRiffle[options, "\n","\t"]]; Abort[]];
		result
	]
)


End[]


EndPackage[]
