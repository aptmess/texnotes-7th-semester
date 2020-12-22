(* ::Package:: *)

BeginPackage["MethodSugiyama`"]


GetDAG::"Graph"="\:0410\:0440\:0433\:0443\:043c\:0435\:043d\:0442 graph \:0434\:043e\:043b\:0436\:0435\:043d \:0431\:044b\:0442\:044c \:0437\:0430\:0434\:0430\:043d \:043a\:0430\:043a \:043e\:0431\:044a\:0435\:043a\:0442 \:0442\:0438\:043f\:0430 Graph.";


GetLayering::"Association"="\:0410\:0440\:0433\:0443\:043c\:0435\:043d\:0442 result \:0434\:043e\:043b\:0436\:0435\:043d \:0431\:044b\:0442\:044c \:0437\:0430\:0434\:0430\:043d \:043a\:0430\:043a \:043e\:0431\:044a\:0435\:043a\:0442 \:0442\:0438\:043f\:0430 Association.";


GetGraph;
AddDummyVertices;


Begin["`Private`"]


(* ::Section:: *)
(*GetGraph*)


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


(* ::Section:: *)
(*GetDAG*)


Options[GetDAG]={ApproachOption->"Cycle Removal"};
GetDAG[graph_,OptionsPattern[]]:=
(
Check[If[!GraphQ[graph],Message[GetDAG::"Graph"]],Abort[]];
With[
	{
		approach=OptionValue[ApproachOption]
	},
	Switch[
		approach,
		"Cycle Removal",
		getDAGVerticesOrder[graph],
		"Random Order",
		getDAGVerticesOrder[graph,getOrderRandom],
		"BFS Order",
		getDAGVerticesOrder[graph,getOrderBFS],
		"DFS Order",
		getDAGVerticesOrder[graph,getOrderDFS],
		"VertexOutDegree Order",
		getDAGVerticesOrder[graph,getOrderVertexOutDegree],
		"IP SCF",
		getDAGSearchSubgraph[graph],
		"IP TI",
		getDAGSearchSubgraph[graph,getSubgraphTI]
	]/;
		MatchQ[
			approach,
			Alternatives["Random Order","BFS Order","DFS Order","VertexOutDegree Order","Cycle Removal","IP SCF","IP TI"]
		]
]
)


getDAGSearchSubgraph[graph_?GraphQ,f_:getSubgraphSCF]:=
With[
	{
		subgraph=f[graph]
	},
	<|"acyclic graph"->subgraph,"feedback set"->Complement[EdgeList[graph],subgraph]|>
]


getSubgraphSCF[graph_]:=
	Module[
		{
			cycles=FindCycle[graph,\[Infinity],All],
			vars,y,
			objFun,con1,getVector,solution
		},
		vars=y/@EdgeList[graph];
		objFun=Total[vars];
		con1={Total[y/@#],{1,1}}&/@cycles;
		getVector=Last[CoefficientArrays[#,vars]]&;
		solution=LinearProgramming[
					getVector[objFun],
					getVector[con1[[All,1]]],
					con1[[All,2]],
					ConstantArray[{0,1},Length[vars]],
					Integers
				];
		Pick[EdgeList[graph],solution,0]
	]


getSubgraphTI[graph_]:=
Module[
	{
		vertices=VertexList[graph],
		arcs=List@@@EdgeList[graph],
		n,varsX,of,step1,con1,rhs1,getVector,sol,mask,pair,order
	},
	n=Length@vertices;
	varsX=x@@@Subsets[vertices,{2}];
	of=Total[arcs/.{{i_Integer,j_}/;i<j:>-x[i,j],{i_Integer,j_}:>x[j,i]}]
	step1=Flatten@Table[x[i,j]+x[j,k]-x[i,k],{i,n-2},{j,i+1,n-1},{k,j+1,n}];
	con1=Join[step1,step1];
	rhs1=Join[ConstantArray[{1,-1},Length@step1],ConstantArray[{0,1},Length@step1]];
	getVector=Last[CoefficientArrays[#,varsX]]&;
	sol=LinearProgramming[getVector@of,getVector@con1,rhs1,ConstantArray[{0,1},Length@varsX],Integers]
	mask=ConstantArray[0,n]
	Do[If[pair[[2]]==1,mask[[pair[[1,2]]]]++,mask[[pair[[1,1]]]]++],{pair,Transpose[{varsX,sol}]}]
	order=Ordering@mask
	Select[EdgeList[graph],MatchQ[order,{___,#[[1]],___,#[[2]],___}]&]
]


getDAGVerticesOrder[graph_?GraphQ,f_:getOrderCycleRemoval]:=
Module[
	{
		order=f[graph],ea
	},
	ea=Select[EdgeList[graph],MatchQ[order,{___,#[[1]],___,#[[2]],___}]&];
	<|"acyclic graph"->ea,"feedback set"->Complement[EdgeList[graph],ea]|>
]


getOrderRandom[graph_]:=RandomSample@VertexList[graph]


getOrderBFS[graph_]:=DeleteDuplicates[Last[Reap@BreadthFirstScan[graph,{"DiscoverVertex"->(Sow[#]&)}]][[1]]]


getOrderDFS[graph_]:=DeleteDuplicates[Last[Reap@DepthFirstScan[graph,1,{"DiscoverVertex"->(Sow[#]&)}]][[1]]]


getOrderVertexOutDegree[graph_]:=Reverse@SortBy[VertexList[graph],VertexOutDegree[graph,#]&]


getSinks[g_?GraphQ]:=Pick[VertexList[g],VertexOutDegree[g],0]


getSources[g_?GraphQ]:=Pick[VertexList[g],VertexInDegree[g],0]


getOrderCycleRemoval[graph_]:=
Module[
	{
		left={},
		right={},
		cutgraph=graph,
		sinks,sources,vertex
	},
	While[
		!EmptyGraphQ[cutgraph],
		sinks=getSinks[cutgraph];
		While[
			sinks!={},
			right=Join[sinks,right];
			cutgraph=VertexDelete[cutgraph,sinks];
			sinks=getSinks[cutgraph]
		];
		sources=getSources[cutgraph];
		While[
			sources!={},
			left=Join[left,sources];
			cutgraph=VertexDelete[cutgraph,sources];
			sources=getSources[cutgraph]
		];
		If[
			!EmptyGraphQ[cutgraph],
			vertex=First[MaximalBy[VertexList[cutgraph],VertexOutDegree[cutgraph,#]-VertexInDegree[cutgraph,#]&]];
			cutgraph=VertexDelete[cutgraph,vertex];
			AppendTo[left,vertex]
		]
	];
	Join[Join[left,VertexList[cutgraph]],right]
]


(* ::Section:: *)
(*GetLayering*)


Options[GetLayering]={ApproachOption->"Longest Path"}
GetLayering[result_,OptionsPattern[]]:=
(
Check[If[!AssociationQ[result],Message[GetLayering::"Association"]],Abort[]];
With[
	{
		dag=unionDAGandFSInAcycicGraph@result,
		approach=OptionValue[ApproachOption]
	},
	Append[result,"layers"->#]&@
		Switch[
			approach,
			"Longest Path",
			getLayeringLPA@dag,
			"Exact",
			getLayeringIPF@dag
		]/;
		MatchQ[
			approach,
			Alternatives["Longest Path","Exact"]
		]
]
)


getLayeringIPF[dag_]:=
Module[
	{
		verticesDAG=VertexList@dag,
		edgesDAG=EdgeList@dag,
		vars\[CapitalLambda],\[Lambda],
		objFun,leftsideconstraint,getVector,solution
	},
	vars\[CapitalLambda]=\[Lambda]/@verticesDAG;
	objFun=Total[Subtract@@@Reverse/@Map[\[Lambda],edgesDAG,{2}]];
	leftsideconstraint=Subtract@@@Reverse/@Map[\[Lambda],edgesDAG,{2}];
	getVector=Last[CoefficientArrays[#,vars\[CapitalLambda]]]&;
	solution=Quiet@LinearProgramming[
						getVector[objFun],
						getVector[leftsideconstraint],
						ConstantArray[{1,1},Length[edgesDAG]],
						ConstantArray[{0,\[Infinity]},Length[vars\[CapitalLambda]]],
						Integers
					];
	SortBy[GatherBy[Transpose[{verticesDAG,solution}],Last],#[[1,2]]&][[All,All,1]]
]


getLayeringLPA[dag_]:=
Module[
	{
		verticesList=VertexList[dag],
		edgesList=EdgeList[dag],
		adjAssoc,U,Z,currentLayer,newlayers,vertex
	},
	adjAssoc=Association@Table[v-><|"parents"-> Select[edgesList,#[[2]]==v&][[All,1]],"children"-> Select[edgesList,#[[1]]==v&][[All,2]]|>,{v,verticesList}];
	U={};
	Z={};
	currentLayer=1;
	newlayers={};
	While[
		!ContainsExactly[verticesList,U],
		vertex=SelectFirst[Complement[verticesList,U],SubsetQ[Z,adjAssoc[#]["children"]]&];
		If[
			!MissingQ[vertex],
			AppendTo[newlayers,{currentLayer,vertex}];
			AppendTo[U,vertex],
			currentLayer++;
			Z=Union[Z,U]
		]
	];
	Reverse[GatherBy[newlayers,First][[All,All,2]]]
]


unionDAGandFSInAcycicGraph[result_Association]:=Graph[DeleteDuplicates@Join[result["acyclic graph"],Reverse/@result["feedback set"]],VertexLabels->"Name"]


(* ::Section:: *)
(*AddDummyVertices*)


Options[AddDummyVertices]={ApproachOption->"Cut"}
AddDummyVertices[result_Association,OptionsPattern[]]:=
(
Check[If[!AssociationQ[result],Message[AddDummyVertices::"Association"]],Abort[]];
With[
	{
		approach=OptionValue[ApproachOption]
	},
	Switch[
		approach,
		"Base",
		baseAddDummyVertices@result,
		"Cut",
		cutAddDummyVertices@result
	]/;
		MatchQ[
			approach,
			Alternatives["Base","Cut"]
		]
]
)


cutAddDummyVertices[result_Association]:=
Module[
	{
		newnames,
		edgeList=EdgeList@unionDAGandFSInAcycicGraph[result],
		arcsWithLongConnections,maxstart,max,
		longEdges,forAdd,vertex,listOfVertices,startLayer,additionalVertices,newEdges,v,
		arcsWithoutLongConnections,newLayersWithDummyVertices,newEdgesWithDummyVertices
	},
	newnames=MapIndexed[v[#2[[1]],#1]&,result["layers"],{2}];
	arcsWithLongConnections=edgeList/.(#[[2]]->#&/@Flatten[newnames]);
	maxstart=max=Max[List@@@edgeList]+1;
	longEdges=GatherBy[Select[arcsWithLongConnections,#[[2,1]]-#[[1,1]]>1&],Last];
	forAdd={};
	Do[
		vertex=subsetLongEdges[[1,2]];
		listOfVertices=subsetLongEdges[[All,1]];
		startLayer=Min[listOfVertices[[All,1]]]+1;
		additionalVertices=v[#,max++]&/@Range[startLayer,vertex[[1]]-1];
		newEdges=DirectedEdge[#,FirstCase[additionalVertices,v[#[[1]]+1,_]]]&/@listOfVertices;
		forAdd=Join[
					forAdd,
					newEdges,
					DirectedEdge@@@Partition[additionalVertices,2,1],
				{DirectedEdge[additionalVertices[[-1]],vertex]}
			],
		{subsetLongEdges,longEdges}
	];
	arcsWithoutLongConnections=Join[DeleteCases[arcsWithLongConnections,Alternatives@@Flatten[longEdges]],forAdd];
	newLayersWithDummyVertices=SortBy[GatherBy[DeleteDuplicates@Flatten[List@@@arcsWithoutLongConnections],First],#[[1,1]]&][[All,All,2]];
	newEdgesWithDummyVertices=arcsWithoutLongConnections[[All,All,2]];
	Join[
		result,
		<|
			"first dummy"->maxstart,
			"layers with dummies"->newLayersWithDummyVertices,
			"graph with dummies"->newEdgesWithDummyVertices
		|>
	]
]


baseAddDummyVertices[result_Association]:=
Module[
	{
		newnames,
		edgeList=EdgeList@unionDAGandFSInAcycicGraph[result],
		rules,arcsWithLongConnections,start,dummynum,
		longArcs,forAdd,parent,child,dummyVertices,startLayer,
		arcsWithoutLongConnections,layersWithDummyVertices,arcsWithDummyVertices
	},
	newnames=MapIndexed[v[#2[[1]],#1]&,result["layers"],{2}];
	rules=MapThread[Rule,{Flatten@result["layers"],Flatten@newnames}];
	arcsWithLongConnections=EdgeList@edgeList/.rules;
	start=dummynum=Max[VertexList@edgeList]+1;
	longArcs=Select[arcsWithLongConnections,#[[2,1]]-#[[1,1]]>1&];
	forAdd={};
	Do[
		{parent,child}=List@@longEdge;
		startLayer=parent[[1]]+1;
		dummyVertices=Table[v[layer,dummynum++],{layer,Range[startLayer,child[[1]]-1]}];
		forAdd=
			Join[
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
	Join[
		result,
		<|
			"first dummy"->start,
			"layers with dummies"->layersWithDummyVertices,
			"graph with dummies"->arcsWithDummyVertices
		|>
	]
]


End[]


EndPackage[]
