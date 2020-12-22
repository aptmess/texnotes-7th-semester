(* ::Package:: *)

(* ::Chapter:: *)
(*Method Sugiyama*)


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


GetLayering::usage="GetLayering[\!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"ApproachOption\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] - \:0434\:043b\:044f \:0430\:0441\:0441\:043e\:0446\:0438\:0430\:0446\:0438\:0438 \!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\) \:043f\:043e\:043b\:0443\:0447\:0435\:043d\:043d\:043e\:0439 \:0432 \:0440\:0435\:0437\:0443\:043b\:044c\:0442\:0430\:0442\:0435 \:0440\:0430\:0431\:043e\:0442\:044b \:0444\:0443\:043d\:043a\:0446\:0438\:0438 GetDAG, \:0440\:0430\:0441\:043f\:0440\:0435\:0434\:0435\:043b\:044f\:0435\:0442 \:0432\:0435\:0440\:0448\:0438\:043d\:044b \:0433\:0440\:0430\:0444\:0430 \:043f\:043e \:0443\:0440\:043e\:0432\:043d\:044f\:043c \*
StyleBox[\"layers,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"] \:0438\:0441\:043f\:043e\:043b\:044c\:0437\:0443\:044f \:043c\:0435\:0442\:043e\:0434, \:043e\:043f\:0440\:0435\:0434\:0435\:043b\:0451\:043d\:043d\:044b\:0439 \:0432 \!\(\*
StyleBox[\"ApproachOption\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\). \:041d\:0430 \:0432\:044b\:0445\:043e\:0434\:0435 \:043f\:043e\:043b\:0443\:0447\:0430\:0435\:0442\:0441\:044f \:0430\:0441\:0441\:043e\:0446\:0438\:0430\:0446\:0438\:044f \:0432\:0438\:0434\:0430: <| acyclic graph -> {}, feedback set -> {}, layers -> {} |>. \n\nGetLayering[\!\(\* 
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"ApproachOption\[Rule]Longest Path\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] - \:0440\:0430\:0441\:043f\:0440\:0435\:0434\:0435\:043b\:044f\:0435\:0442 \:0432\:0435\:0440\:0448\:0438\:043d\:044b \:0441 \:043f\:043e\:043c\:043e\:0449\:044c\:044e \:043c\:0435\:0442\:043e\:0434\:0430 \:0434\:043b\:0438\:043d\:0435\:0439\:0448\:0435\:0433\:043e \:043f\:0443\:0442\:0438. \n\nGetLayering[\!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"ApproachOption\[Rule]Exact\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] - \:0440\:0430\:0441\:043f\:0440\:0435\:0434\:0435\:043b\:044f\:0435\:0442 \:0432\:0435\:0440\:0448\:0438\:043d\:044b \:0441 \:043f\:043e\:043c\:043e\:0449\:044c\:044e \:0440\:0435\:0448\:0435\:043d\:0438\:044f \:0437\:0430\:0434\:0430\:0447\:0438 \:043b\:0438\:043d\:0435\:0439\:043d\:043e\:0433\:043e \:043f\:0440\:043e\:0433\:0440\:0430\:043c\:043c\:0438\:0440\:043e\:0432\:0430\:043d\:0438\:044f. \n\nGetLayering[\!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"ApproachOption\[Rule]Min Width\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] - \:0440\:0430\:0441\:043f\:0440\:0435\:0434\:0435\:043b\:044f\:0435\:0442 \:0432\:0435\:0440\:0448\:0438\:043d\:044b \:0441 \:043f\:043e\:043c\:043e\:0449\:044c\:044e \:044d\:0432\:0440\:0438\:0441\:0442\:0438\:0447\:0435\:0441\:043a\:043e\:0433\:043e \:0430\:043b\:0433\:043e\:0440\:0438\:0442\:043c\:0430 \:0441 \:043c\:0438\:043d\:0438\:043c\:0438\:0437\:0430\:0446\:0438\:0435\:0439 \:0448\:0438\:0440\:0438\:043d\:044b \:0441\:043b\:043e\:0451\:0432. \n\nGetLayering[\!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"ApproachOption\[Rule]{Min Width, W, c}\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] - \:0440\:0430\:0441\:043f\:0440\:0435\:0434\:0435\:043b\:044f\:0435\:0442 \:0432\:0435\:0440\:0448\:0438\:043d\:044b \:0441 \:043f\:043e\:043c\:043e\:0449\:044c\:044e \:044d\:0432\:0440\:0438\:0441\:0442\:0438\:0447\:0435\:0441\:043a\:043e\:0433\:043e \:0430\:043b\:0433\:043e\:0440\:0438\:0442\:043c\:0430 \:0441 \:043c\:0438\:043d\:0438\:043c\:0438\:0437\:0430\:0446\:0438\:0435\:0439 \:0448\:0438\:0440\:0438\:043d\:044b \:0441\:043b\:043e\:0451\:0432, \:0433\:0434\:0435 \*
StyleBox[\"W\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"] - \:043c\:0430\:043a\:0441\:0438\:043c\:0430\:043b\:044c\:043d\:0430 \:0448\:0438\:0440\:0438\:043d\:0430 \:0441\:043b\:043e\:044f, \!\(\*
StyleBox[\"c\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\) - \:0433\:043b\:0443\:0431\:0438\:043d\:0430 \:043f\:0440\:043e\:0441\:043c\:043e\:0442\:0440\:0430 \:0441\:043b\:043e\:0451\:0432.  \n\nGetLayering[\!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"ApproachOption\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] \!\(\*
StyleBox[\"ImprovmentOption -> True\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] - \:0418\:0441\:043f\:043e\:043b\:044c\:0437\:0443\:0435\:0442 \:0443\:043b\:0443\:0447\:0448\:0430\:044e\:0449\:0443\:044e \:044d\:0432\:0440\:0438\:0441\:0442\:0438\:043a\:0443.";


AddDummyVertices::usage="AddDummyVertices[\!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"ApproachOption\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] - \:0434\:043b\:044f \:0430\:0441\:0441\:043e\:0446\:0438\:0430\:0446\:0438\:0438 \!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\) \:043f\:043e\:043b\:0443\:0447\:0435\:043d\:043d\:043e\:0439 \:0432 \:0440\:0435\:0437\:0443\:043b\:044c\:0442\:0430\:0442\:0435 \:0440\:0430\:0431\:043e\:0442\:044b \:0444\:0443\:043d\:043a\:0446\:0438\:0438 GetLayering, \:0440\:0430\:0437\:0431\:0438\:0432\:0430\:0435\:0442 \:0434\:043b\:0438\:043d\:043d\:044b\:0435 \:0440\:0451\:0431\:0440\:0430 \:0433\:0440\:0430\:0444\:0430 \:043d\:0430 \:043a\:043e\:0440\:043e\:0442\:043a\:0438\:0435, \:0434\:043e\:0431\:0430\:0432\:043b\:044f\:044f \*
StyleBox[\"Dummy verteces,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"] - \:0444\:0438\:043a\:0442\:0438\:0432\:043d\:044b\:0435 \:0432\:0435\:0440\:0448\:0438\:043d\:044b. \:041d\:0430 \:0432\:044b\:0445\:043e\:0434\:0435 \:043f\:043e\:043b\:0443\:0447\:0430\:0435\:0442\:0441\:044f \:0430\:0441\:0441\:043e\:0446\:0438\:0430\:0446\:0438\:044f \:0432\:0438\:0434\:0430: <| acyclic graph -> {}, feedback set -> {}, layers with dummies-> {}, first dummy-> \:043d\:043e\:043c\:0435\:0440 \:043f\:0435\:0440\:0432\:043e\:0439 \:0444\:0438\:043a\:0442\:0438\:0432\:043d\:043e\:0439 \:0432\:0435\:0440\:0448\:0438\:043d\:044b |>. \n\nAddDummyVertices[\!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"ApproachOption -> Base\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] - \:0430\:043b\:0433\:043e\:0440\:0438\:0442\:043c, \:043a\:043e\:0442\:043e\:0440\:044b\:0439 \:0434\:043e\:0431\:0430\:0432\:043b\:044f\:0435\:0442 \:0432\:0441\:0435 \:0432\:043e\:0437\:043c\:043e\:0436\:043d\:044b\:0435 \:0444\:0438\:043a\:0442\:0438\:0432\:043d\:044b\:0435 \:0432\:0435\:0440\:0448\:0438\:043d\:044b. \n\nAddDummyVertices[\!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"ApproachOption -> Cut\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] - \:0430\:043b\:0433\:043e\:0440\:0438\:0442\:043c \:0443\:0434\:0430\:043b\:0435\:043d\:0438\:044f \:0434\:043b\:0438\:043d\:043d\:044b\:0445 \:0440\:0435\:0431\:0435\:0440 \:0441 \:0434\:043e\:0431\:0430\:0432\:043b\:0435\:043d\:0438\:0435\:043c \:0441\:043e\:043a\:0440\:0430\:0449\:0435\:043d\:043d\:043e\:0433\:043e \:0447\:0438\:0441\:043b\:0430 \:0444\:0438\:043a\:0442\:0438\:0432\:043d\:044b\:0445 \:0432\:0435\:0440\:0448\:0438\:043d.";


GetVertexOrder::usage="GetVertexOrder[\!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"ApproachOption\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] - \:0434\:043b\:044f \:0430\:0441\:0441\:043e\:0446\:0438\:0430\:0446\:0438\:0438 \!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\) \:043f\:043e\:043b\:0443\:0447\:0435\:043d\:043d\:043e\:0439 \:0432 \:0440\:0435\:0437\:0443\:043b\:044c\:0442\:0430\:0442\:0435 \:0440\:0430\:0431\:043e\:0442\:044b \:0444\:0443\:043d\:043a\:0446\:0438\:0438 AddDummyVertices, \:0443\:043f\:043e\:0440\:044f\:0434\:043e\:0447\:0438\:0432\:0430\:0435\:0442 \:0432\:0435\:0440\:0448\:0438\:043d\:044b \:043d\:0430 \:0441\:043b\:043e\:044f\:0445, \:043c\:0438\:043d\:0438\:043c\:0438\:0437\:0438\:0440\:0443\:044f \:0447\:0438\:0441\:043b\:043e \:043f\:0435\:0440\:0435\:0441\:0435\:0447\:0435\:043d\:0438\:0439 \:0440\:0451\:0431\:0435\:0440.  \:041d\:0430 \:0432\:044b\:0445\:043e\:0434\:0435 \:043f\:043e\:043b\:0443\:0447\:0430\:0435\:0442\:0441\:044f \:0430\:0441\:0441\:043e\:0446\:0438\:0430\:0446\:0438\:044f \:0432\:0438\:0434\:0430: <| acyclic graph -> {}, feedback set -> {}, layers with dummies-> {}, first dummy-> \:043d\:043e\:043c\:0435\:0440 \:043f\:0435\:0440\:0432\:043e\:0439 \:0444\:0438\:043a\:0442\:0438\:0432\:043d\:043e\:0439 \:0432\:0435\:0440\:0448\:0438\:043d\:044b |>. \n\nGetVertexOrder[\!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"ApproachOption -> Barycenter\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] - \:0443\:043f\:043e\:0440\:044f\:0434\:043e\:0447\:0438\:0432\:0430\:0435\:0442 \:0432\:0435\:0440\:0448\:0438\:043d\:044b \:043d\:0430 \:0443\:0440\:043e\:0432\:043d\:044f\:0445 \:043c\:0435\:0442\:043e\:0434\:043e\:043c \:0431\:0430\:0440\:0438\:0446\:0435\:043d\:0442\:0440\:043e\:0432. \n\nGetVertexOrder[\!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"ApproachOption -> {Barycenter, iter}\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] - \:0443\:043f\:043e\:0440\:044f\:0434\:043e\:0447\:0438\:0432\:0430\:0435\:0442 \:0432\:0435\:0440\:0448\:0438\:043d\:044b \:043d\:0430 \:0443\:0440\:043e\:0432\:043d\:044f\:0445 \:043c\:0435\:0442\:043e\:0434\:043e\:043c \:0431\:0430\:0440\:0438\:0446\:0435\:043d\:0442\:0440\:043e\:0432 c \:043e\:0433\:0440\:0430\:043d\:0438\:0447\:0435\:043d\:0438\:0435\:043c \:0447\:0438\:0441\:043b\:0430 \:0438\:0442\:0435\:0440\:0430\:0446\:0438\:0439. \n\nGetVertexOrder[\!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"ApproachOption -> Matheuristic\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] - \:0443\:043f\:043e\:0440\:044f\:0434\:043e\:0447\:0438\:0432\:0430\:0435\:0442 \:0432\:0435\:0440\:0448\:0438\:043d\:044b \:043d\:0430 \:0443\:0440\:043e\:0432\:043d\:044f\:0445, \:0438\:0441\:043f\:043e\:043b\:044c\:0437\:0443\:044f \:043c\:0430\:0442\:044d\:0432\:0440\:0438\:0441\:0442\:0438\:0447\:0435\:0441\:043a\:0438\:043c \:0430\:043b\:0433\:043e\:0440\:0438\:0442\:043c.";


GetCoordinates::usage"GetCoordinates[\!\(\*
StyleBox[\"assoc,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"YDistanceOption,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"XDistanceOption,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"WeightsOption,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)].";


MyLayeredGraphPlot::usage="MyLayeredGraphPlot[\!\(\*
StyleBox[\"graph,\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"methods\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"opts\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\)] -  \:043e\:0442\:0440\:0438\:0441\:043e\:0432\:044b\:0432\:0430\:0435\:0442 \:0443\:043a\:043b\:0430\:0434\:043a\:0443 \:0433\:0440\:0430\:0444\:0430 \!\(\*
StyleBox[\"graph\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\) \:0441 \:043f\:0440\:0438\:043c\:0435\:043d\:0435\:043d\:0438\:0435\:043c \:043c\:0435\:0442\:043e\:0434\:043e\:0432, \:0443\:043a\:0430\:0437\:0430\:043d\:043d\:044b\:0445 \:0432 \:0430\:0441\:0441\:043e\:0446\:0438\:0430\:0446\:0438\:0438 \!\(\*
StyleBox[\"methods\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\), \:043c\:0435\:0442\:043e\:0434\:043e\:043c, \:043a\:043e\:0442\:043e\:0440\:044b\:0439 \:0437\:0430\:0434\:0430\:0451\:0442 \:043f\:0430\:0440\:0430\:043c\:0435\:0442\:0440 \!\(\*
StyleBox[\"opts\",\nFontFamily->\"Times New Roman\",\nFontSlant->\"Italic\"]\).";


GetDAG::"Graph"="\:0410\:0440\:0433\:0443\:043c\:0435\:043d\:0442 graph \:0434\:043e\:043b\:0436\:0435\:043d \:0431\:044b\:0442\:044c \:0437\:0430\:0434\:0430\:043d \:043a\:0430\:043a \:043e\:0431\:044a\:0435\:043a\:0442 \:0442\:0438\:043f\:0430 Graph.";


GetDAG::option="Option `1` is not in list of options. Choose another one from the list: \n`2`";


GetDAG::RESoption="Option `1` is not in list of ResOptions. Choose another one from the list: \n`2`";


GetLayering::option = "Option `1` is not in list of options. Choose another one from the list: \n`2`";


AddDummyVertices::option = "Option `1` is not in list of options. Choose another one from the list: \n`2`";


GetVertexOrder::option = "Option `1` is not in list of options. Choose another one from the list: \n`2`";


MyLayeredGraphPlot::option = "\nOption `1` is not in list of options. \nChoose another one from the list: \n`2`";


GetCoordinates::option = "\nValue `1` is not positive real.";
GetCoordinates::option2 = "\n `1` is not valid input weights. Please write in this form: {w1, w2, w3}";


MyLayeredGraphPlot::option = "Option `1` is not in list of options. Choose another one from the list: \n`2`";


getOrderRandom;(*Random Order*)
BFSearch;(*BFS Order*)
DFSearch;(*DFS Order*)
DDVertex;(*VertexOutDegreeOrder*)
GreedyCycleRemoval;(*Cycle Removal*)
SetCoveringFormulation;(*IP SCF*)
getAcyclicTriangle;(*IP TI*)


Begin["`Private`"]


(* ::Chapter:: *)
(*0. GetGraph*)


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


(* ::Chapter::Closed:: *)
(*1. GetDaG - \:0443\:0434\:0430\:043b\:0435\:043d\:0438\:0435 \:0446\:0438\:043a\:043b\:043e\:0432*)


(* ::Section::Closed:: *)
(*1.0 Useful Functions*)


sinkV[g_?GraphQ]:=Pick[VertexList[g],VertexOutDegree[g],False]


sourceV[g_?GraphQ]:=Pick[VertexList[g],VertexInDegree[g],False]


acANDfs[G_?GraphQ,sort_]:=Module[{e=EdgeList[G],sortV = sort[G],mask,ACyG,FS},
mask = Table[MatchQ[sortV ,{___,edg[[1]],___,edg[[2]],___}],{edg,e}];(*\:043f\:0440\:043e\:0432\:0435\:0440\:044f\:0435\:043c, \:043b\:0435\:0432\:0435\:0435 \:043b\:0438 \:0440\:043e\:0434\:0438\:0442\:0435\:043b\:044c \:043f\:043e\:0442\:043e\:043c\:043a\:0430 \:043f\:043e \:0441\:043e\:043e\:0442\:0432\:0435\:0441\:0442\:0432\:0435\:043d\:043d\:043e\:0439 \:0441\:043e\:0440\:0442\:0438\:0440\:043e\:0432\:043a\:0435*)
ACyG = Pick[e,mask,True];
FS= Pick[e,mask,False];
<|"acyclic graph"->ACyG, "feedback set"->FS|>
]


(* ::Section::Closed:: *)
(*1.1 Random Order*)


Clear[getOrderRandom]
getOrderRandom[graph_]:=RandomSample@VertexList[graph]


(* ::Section::Closed:: *)
(*1.2 DFS Order*)


Clear[DFSearch]; 
DFSearch[G_?GraphQ]:=Reap[DepthFirstScan[G,{"DiscoverVertex"->(Sow[#]&)}]][[-1]][[1]];


(* ::Section::Closed:: *)
(*1.3 BFS Order*)


Clear[BFSearch];
BFSearch[G_?GraphQ]:=DeleteDuplicates[Reap[BreadthFirstScan[G,{"DiscoverVertex"->(Sow[#]&)}]][[-1]][[1]]];


(* ::Section::Closed:: *)
(*1.4 VertexOutDegree Order*)


Clear[DDVertex];
DDVertex[G_?GraphQ]:=Keys[ReverseSort[Association[Thread[VertexList[G]->VertexOutDegree[G]]]]]


(* ::Section::Closed:: *)
(*1.5 Cycle Removal*)


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
		sinks=sinkV[cutgraph];
		While[
			sinks!={},
			right=Join[sinks,right];
			cutgraph=VertexDelete[cutgraph,sinks];
			sinks=sinkV[cutgraph]
		];
		sources=sourceV[cutgraph];
		While[
			sources!={},
			left=Join[left,sources];
			cutgraph=VertexDelete[cutgraph,sources];
			sources=sourceV[cutgraph]
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


(* ::Section::Closed:: *)
(*1.6 IP SCF*)


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


(* ::Section::Closed:: *)
(*1.7 IP TI*)


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


(* ::Section::Closed:: *)
(*1.8 GetDAG*)


Attributes[GetDAG]={ReadProtected};
Options[GetDAG]={ApproachOption->"Random Order", ResultOption->"full"};
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
			opt={"Random Order","BFS Order","DFS Order","VertexOutDegree Order","Cycle Removal","IP SCF","IP TI"},
			resoption={"full","acyclic graph","feedback set"},
			approach=OptionValue[ApproachOption],
			resOption=OptionValue[ResultOption]
		},
		If[MemberQ[opt,approach],
		Which[
		approach==="Random Order", result = acANDfs[graph,getOrderRandom],
		approach==="BFS Order", result = acANDfs[graph,BFSearch],
		approach==="DFS Order", result = acANDfs[graph,DFSearch],
		approach==="VertexOutDegree Order", result = acANDfs[graph,DDVertex],
		approach==="Cycle Removal", result = acANDfs[graph,getOrderCycleRemoval],
		approach==="IP SCF", result = SetCoveringFormulation[graph,ConstantArray[1,Length[EdgeList[graph]]]],
		approach==="IP TI", result = getAcyclicTriangle[graph]
		], Message[GetDAG::option,approach, StringRiffle[opt, "\n","\t"]]; Abort[]];
		If[MemberQ[resoption,resOption],
		Which[resOption==="full",result,
		resOption==="acyclic graph",result["acyclic graph"],resOption==="feedback set",result["feedback set"]],
		Message[GetDAG::RESoption,resOption, StringRiffle[resoption, "\n","\t"]]; Abort[]]
	]
)


(* ::Chapter::Closed:: *)
(*2. GetLayering - \:0440\:0430\:0437\:0431\:0438\:0435\:043d\:0438\:0435 \:043d\:0430 \:0441\:043b\:043e\:0438*)


(* ::Section::Closed:: *)
(*2.1 Longest Path*)


LayeringLongestPath[getDagResult_]:=Module[
{g=Graph[Union[getDagResult["acyclic graph"],Reverse/@getDagResult["feedback set"]]],adjAssoc,U,Z,currentLayer,newlayers,vertex,verticesList,edgesList},
verticesList=VertexList[g];
edgesList=EdgeList[g];
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
<|"acyclic graph"->getDagResult["acyclic graph"], "feedback set"->getDagResult["feedback set"],"layers"->Reverse[GatherBy[newlayers,First][[All,All,2]]]|>

]


(* ::Section::Closed:: *)
(*2.2 Exact*)


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


(* ::Section::Closed:: *)
(*2.3 Improvment Heuristic*)


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

ImproveHeuristic[DAG_]:=Module[{
g=Graph[Union[DAG["acyclic graph"],Reverse/@DAG["feedback set"]],VertexLabels->"Name"],
newnames,resultLayer,betterlayers},
V = Flatten[DAG["layers"]];
relations=Association[Table[v-><|"parents"->Cases[IncidenceList[g,v],e_\[DirectedEdge]h_/;h==v->e],
"children"->Cases[IncidenceList[g,v],e_\[DirectedEdge]h_/;e==v->h]|>,{v,V}]];
newnames=MapIndexed[v[#2[[1]],#1]&,DAG["layers"],{2}];
layer=Association[Thread[Flatten@DAG["layers"]->Flatten[newnames][[All,1]]]];
resultLayer=VertexPromotionHeuristic[];betterlayers=GatherBy[Normal[resultLayer],Last][[All,All,1]];
<|"acyclic graph"->DAG["acyclic graph"],"feedback set"->DAG["feedback set"],"layers"->betterlayers|>]


(* ::Section::Closed:: *)
(*2.4 Min Width(W, c)*)


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
];l=Reverse[GatherBy[newlayers,First][[All,All,2]]];
<|"acyclic graph"->getDagResult["acyclic graph"], "feedback set"->getDagResult["feedback set"],"layers"->l|>]


(* ::Section:: *)
(*2.5 GetLayering*)


Attributes[GetLayering]={ReadProtected};
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


(* ::Chapter::Closed:: *)
(*3. AddDummyVertices - \:0434\:043e\:0431\:0430\:0432\:043b\:0435\:043d\:0438\:0435 \:0444\:0438\:043a\:0442\:0438\:0432\:043d\:044b\:0445 \:0432\:0435\:0440\:0448\:0438\:043d*)


(* ::Section::Closed:: *)
(*3.0 Useful Functions*)


Clear[unionDAGandFSInAcycicGraph]
unionDAGandFSInAcycicGraph[result_Association]:=Graph[DeleteDuplicates@Join[result["acyclic graph"],Reverse/@result["feedback set"]],VertexLabels->"Name"]


(* ::Section::Closed:: *)
(*3.1 Base*)


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


(* ::Section::Closed:: *)
(*3.2 Cut*)


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


(* ::Section::Closed:: *)
(*3.3 AddDummyVertices*)


Attributes[AddDummyVertices]={ReadProtected};
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
			approach==="Cut", result = cutAddDummyVertices[gLayerRes]
		], 
		Message[AddDummyVertices::option, approach, StringRiffle[options, "\n","\t"]]; Abort[]];
		result
	]
)


(* ::Chapter:: *)
(*4. GetVertexOrder - \:043c\:0438\:043d\:0438\:043c\:0438\:0437\:0430\:0446\:0438\:044f \:0447\:0438\:0441\:043b\:0430 \:043f\:0435\:0440\:0435\:0441\:0435\:0447\:0435\:043d\:0438\:0439 \:0440\:0435\:0431\:0435\:0440*)


(* ::Section::Closed:: *)
(*4.0 Useful Functions*)


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


(* ::Section::Closed:: *)
(* 4.1 BaryCenter*)


Clear[getBarycenterValue]
getBarycenterValue[order_,adjVertices_]:=Mean@Flatten@Position[order,Alternatives@@adjVertices]
getBarycenterValue[order_,{}]:=-1


Clear[anotherLayer]
anotherLayer[num_,"children"]:=num+1
anotherLayer[num_,"parents"]:=num-1


Clear[iterationsLayers]
iterationsLayers[length_,"children"]:=Range[length-1,1,-1]
iterationsLayers[length_,"parents"]:=Range[2,length]


Clear[getBarycenter]
getBarycenter[order0_,adjAssoc_,fix_]:=
Module[
{order=order0,meanpositions,sortVertices,mask},
Do[
meanpositions={#,getBarycenterValue[order[[anotherLayer[num,fix]]],adjAssoc[#][fix]]}&/@order[[num]];
sortVertices=SortBy[DeleteCases[meanpositions,{_,-1}],Last];
sortVertices=Flatten[If[Length[#]>1,Cases[order[[num]],Alternatives@@#[[All,1]]],#[[1,1]]]&/@GatherBy[sortVertices,Last]];
mask=(meanpositions/.{{_,a_}/;a!=-1:>{Missing[]}})[[All,1]];
Do[
If[
MissingQ@mask[[i]],
mask[[i]]=First[sortVertices];
sortVertices=Rest[sortVertices]
],
{i,Length[mask]}
];
order[[num]]=mask,
{num,iterationsLayers[Length[order],"children"]}
];
order
]


ClearAll[mainBarycenter]
mainBarycenter[gDummiesRes_,layers_, arcs_, iterations_:5] :=
Module[
{
order = layers,
ResultOrder,
adjAssoc=Association@Table[v-><|"parents"-> Select[arcs,#[[2]]==v&][[All,1]],"children"-> Select[arcs,#[[1]]==v&][[All,2]]|>,{v,Flatten[layers,1]}],
edgesLayers=SortBy[GatherBy[arcs,FirstPosition[layers,#[[1]]][[1]]&],FirstPosition[layers,#[[1,1]]][[1]]&],
results = {} ,crossings
},
Table[
If[
Mod[it, 2] == 0,(*test*)
order=getBarycenter[order,adjAssoc,"children"],(*else*)
order=getBarycenter[order,adjAssoc,"parents"]
];
AppendTo[results, {order, Total@MapThread[getNumberOfCrossings,{edgesLayers,Partition[order,2,1]}]}],
{it, iterations}(*cycle*)
   ];
   ResultOrder=MinimalBy[results,Last][[1, 1]];
<|"acyclic graph"->gDummiesRes["acyclic graph"], 
"feedback set"->gDummiesRes["feedback set"],
"graph with dummies"->gDummiesRes["graph with dummies"],
"layers with dummies"->ResultOrder,
"first dummy"->gDummiesRes["first dummy"]|>
]


(* ::Section::Closed:: *)
(*4.2 MathHeuristic*)


Clear[f1con1]
f1con1[cvar_]:={{-cvar-y@@cvar[[All,2]]+x@@cvar[[All,1]],{0,-1}},{cvar-y@@cvar[[All,2]]+x@@cvar[[All,1]],{0,1}}}(*\:043e\:0433\:0440\:0430\:043d\:0438\:0447\:0435\:043d\:0438\:0435 1*)


Clear[f1con2]
f1con2[cvar_]:={{-cvar-y@@Sort[cvar[[All,2]]]-x@@cvar[[All,1]],{-1,-1}},{-cvar+y@@Sort[cvar[[All,2]]]+x@@cvar[[All,1]],{1,-1}}}(*\:043e\:0433\:0440\:0430\:043d\:0438\:0447\:0435\:043d\:0438\:0435 2*)


Clear[getNodeOrdering]
getNodeOrdering[layers_,arcs_]:=
Module[
{
cVarList=Cases[Subsets[arcs,{2}],{e1_,e2_}/;And[e1[[1]]=!=e2[[1]],e1[[2]]=!=e2[[2]]]:>c[e1,e2]],
xVarList=x@@@Subsets[layers[[1]],{2}],
yVarList=y@@@Subsets[layers[[2]],{2}],
varList,con1and2,list3x,con3,list3y,con4,objFun,cons,ma,result,xs,ys,firstLayer,secondLayer
},
varList=Join[cVarList,xVarList,yVarList];
con1and2=Flatten[Table[If[cvar[[1,2]]<cvar[[2,2]],f1con1[cvar],f1con2[cvar]],{cvar,cVarList}],1];
list3x=Cases[Subsets[xVarList,{3}],{_[i_,j_],_[i_,k_],_[j_,k_]}];
con3=Flatten[Table[{{setOfX[[1]]-setOfX[[2]]+setOfX[[3]],{0,1}},{setOfX[[1]]-setOfX[[2]]+setOfX[[3]],{1,-1}}},{setOfX,list3x}],1];
list3y=Cases[Subsets[yVarList,{3}],{_[i_,j_],_[i_,k_],_[j_,k_]}];
con4=Flatten[Table[{{setOfY[[1]]-setOfY[[2]]+setOfY[[3]],{0,1}},{setOfY[[1]]-setOfY[[2]]+setOfY[[3]],{1,-1}}},{setOfY,list3y}],1];
objFun=Last[CoefficientArrays[Total[cVarList],varList]];
cons=Join[con1and2,con3,con4];
ma=Last[CoefficientArrays[cons[[All,1]],varList]];
result=Transpose[{varList,LinearProgramming[objFun,ma,cons[[All,2]],ConstantArray[{0,1},Length[varList]],Integers]}];
xs=Cases[result,{x[_,_],_}];
ys=Cases[result,{y[_,_],_}];
=Join[Complement[layers[[1]],#],#]&@SortBy[Tally[If[#[[2]]==0,#[[1,1]],#[[1,2]]]&/@xs],Last][[All,1]];
secondLayer=Join[Complement[layers[[2]],#],#]&@SortBy[Tally[If[#[[2]]==0,#[[1,1]],#[[1,2]]]&/@ys],Last][[All,1]];{firstLayer,secondLayer}]


Clear[getNodeOrderingFixTop]
getNodeOrderingFixTop[layers_,arcs_]:=
Module[
{
cVarList=Cases[Subsets[arcs,{2}],{e1_,e2_}/;And[e1[[1]]=!=e2[[1]],e1[[2]]=!=e2[[2]]]:>c[e1,e2]],
xVarList=x@@@Subsets[layers[[1]],{2}],
yVarList=y@@@Subsets[layers[[2]],{2}],
varList,con1and2,con3,list3y,con4,objFun,cons,ma,result,xs,ys,firstLayer,secondLayer
},
varList=Join[cVarList,xVarList,yVarList];
con1and2=Flatten[Table[If[cvar[[1,2]]<cvar[[2,2]],f1con1[cvar],f1con2[cvar]],{cvar,cVarList}],1];
con3=xVarList/.{a:x[__]:>{a,{1,0}}};list3y=Cases[Subsets[yVarList,{3}],{_[i_,j_],_[i_,k_],_[j_,k_]}];
con4=Flatten[Table[{{setOfY[[1]]-setOfY[[2]]+setOfY[[3]],{0,1}},{setOfY[[1]]-setOfY[[2]]+setOfY[[3]],{1,-1}}},{setOfY,list3y}],1];
objFun=Last[CoefficientArrays[Total[cVarList],varList]];
cons=Join[con1and2,con3,con4];
ma=Last[CoefficientArrays[cons[[All,1]],varList]];
result=Transpose[{varList,LinearProgramming[objFun,ma,cons[[All,2]],ConstantArray[{0,1},Length[varList]],Integers]}];
ys=Cases[result,{y[_,_],_}];
firstLayer=layers[[1]];
secondLayer=Join[Complement[layers[[2]],#],#]&@SortBy[Tally[If[#[[2]]==0,#[[1,1]],#[[1,2]]]&/@ys],Last][[All,1]];{firstLayer,secondLayer}]


Clear[getNodeOrderingFixBottom]
getNodeOrderingFixBottom[layers_,arcs_]:=
Module[
{
cVarList=Cases[Subsets[arcs,{2}],{e1_,e2_}/;And[e1[[1]]=!=e2[[1]],e1[[2]]=!=e2[[2]]]:>c[e1,e2]],
xVarList=x@@@Subsets[layers[[1]],{2}],
yVarList=y@@@Subsets[layers[[2]],{2}],
varList,con1and2,con3,list3x,con4,objFun,cons,ma,result,xs,ys,firstLayer,secondLayer
},
varList=Join[cVarList,xVarList,yVarList];
con1and2=Flatten[Table[If[cvar[[1,2]]<cvar[[2,2]],f1con1[cvar],f1con2[cvar]],{cvar,cVarList}],1];
list3x=Cases[Subsets[xVarList,{3}],{_[i_,j_],_[i_,k_],_[j_,k_]}];
con3=Flatten[Table[{{setOfX[[1]]-setOfX[[2]]+setOfX[[3]],{0,1}},{setOfX[[1]]-setOfX[[2]]+setOfX[[3]],{1,-1}}},{setOfX,list3x}],1];
con4=yVarList/.{a:y[__]:>{a,{1,0}}};
objFun=Last[CoefficientArrays[Total[cVarList],varList]];
cons=Join[con1and2,con3,con4];ma=Last[CoefficientArrays[cons[[All,1]],varList]];
result=Transpose[{varList,LinearProgramming[objFun,ma,cons[[All,2]],ConstantArray[{0,1},Length[varList]],Integers]}];
xs=Cases[result,{x[_,_],_}];
firstLayer=Join[Complement[layers[[1]],#],#]&@SortBy[Tally[If[#[[2]]==0,#[[1,1]],#[[1,2]]]&/@xs],Last][[All,1]];
secondLayer=layers[[2]];{firstLayer,secondLayer}]


ClearAll[mainExact]
mainExact[gDummiesRes_,layers_, arcs_, iterations_:1] :=
Module[
{
order = layers,solution,
edgesLayers=SortBy[GatherBy[arcs,FirstPosition[layers,#[[1]]][[1]]&],FirstPosition[layers,#[[1,1]]][[1]]&],
results = {} ,crossings,L
},
Table[
If[
Mod[it, 2] == 0,
Table[
If[
Min[Length/@order[[{i-1,i}]]]>1,
solution=getNodeOrderingFixBottom[order[[{i-1,i}]],edgesLayers[[i]]];order[[{i-1,i}]]=solution
],
{i,Length[order],2,-1}], 
Table[
If[
Min[Length/@order[[{i,i+1}]]]>1,
If[
i==1,
If[
it==1,
solution=getNodeOrdering[order[[{i,i+1}]],edgesLayers[[i]]],
solution=getNodeOrderingFixTop[order[[{i,i+1}]],edgesLayers[[i]]]
],
solution=getNodeOrderingFixTop[order[[{i,i+1}]],edgesLayers[[i]]]
];
order[[{i,i+1}]]=solution
],
{i,Length[order]-1}
]
];
AppendTo[results, {order, Total@MapThread[getNumberOfCrossings,{edgesLayers,Partition[order,2,1]}]}],
{it, iterations}
];
L=MinimalBy[results,Last][[1,1]];
<|"acyclic graph"->gDummiesRes["acyclic graph"], 
"feedback set"->gDummiesRes["feedback set"],
"graph with dummies"->gDummiesRes["graph with dummies"],
"layers with dummies"->L,
"first dummy"->gDummiesRes["first dummy"]|>
]


(* ::Section::Closed:: *)
(*4.3 GetVertexOrder*)


Clear[GetVertexOrder]
Attributes[GetVertexOrder]={ReadProtected};
Options[GetVertexOrder]={ApproachOption->"Barycenter"};
GetVertexOrder[gDummiesRes_,OptionsPattern[]]:=
(
	Module[
		{
			result, l, layers,rules,edges,y,arcs,m,
			options={"Barycenter","Matheuristic", "{Barycenter,maxNumberOfIterations_Integer?Positive}"},
			approach=OptionValue[ApproachOption]
		},
		l=gDummiesRes["layers with dummies"];
		edges=gDummiesRes["graph with dummies"];
		m = MatchQ[approach,{"Barycenter",_?IntegerQ}];
		If[MemberQ[options,approach] || m == True,
		Which[
			approach==="Barycenter", result = mainBarycenter[gDummiesRes, l, edges, 5],
			approach==="Matheuristic", result = Quiet[mainExact[gDummiesRes, l, edges, 1]],
			m===True, result=mainBarycenter[gDummiesRes, l, edges, approach[[2]]]
		], 
		Message[GetVertexOrder::option, approach, StringRiffle[options, "\n","\t"]]; Abort[]];
		result
	]
)


(* ::Chapter:: *)
(*5. GetCoordinates - \:043e\:043f\:0440\:0435\:0434\:0435\:043b\:0435\:043d\:0438\:0435 \:043a\:043e\:043e\:0440\:0434\:0438\:043d\:0430\:0442 \:0432\:0435\:0440\:0448\:0438\:043d*)


(* ::Section::Closed:: *)
(*5.1 GetCoordinates*)


Clear[GetCoordinates]
Attributes[GetCoordinates]={ReadProtected};
Options[GetCoordinates]={YDistanceOption->1,XDistanceOption->1,WeightsOption->{1,1,1}};

GetCoordinates::usage="\:041d\:0430 \:0432\:0445\:043e\:0434 \:043f\:0440\:0438\:043d\:0438\:043c\:0430\:0435\:0442 \:0440\:0435\:0437\:0443\:043b\:044c\:0442\:0430\:0442 \:0440\:0430\:0431\:043e\:0442\:044b GetVertexOrder. \:041e\:043f\:0446\:0438\:0438:
YDistanceOption \[Rule] 1 \[Dash] \:0440\:0430\:0441\:0441\:0442\:043e\:044f\:043d\:0438\:0435 \:043c\:0435\:0436\:0434\:0443 \:0441\:043b\:043e\:044f\:043c\:0438;
XDistanceOption \[Rule] 1 \[Dash] \:043c\:0438\:043d\:0438\:043c\:0430\:043b\:044c\:043d\:043e\:0439 \:0440\:0430\:0441\:0441\:0442\:043e\:044f\:043d\:0438\:0435 \:043c\:0435\:0436\:0434\:0443 \:0432\:0435\:0440\:0448\:0438\:043d\:0430\:043c\:0438 \:043d\:0430 \:0441\:043b\:043e\:0435;
WeightsOption \[Rule] {1, 1, 1} \[Dash] \:0437\:043d\:0430\:0447\:0438\:043c\:043e\:0441\:0442\:044c \:0432\:0435\:0440\:0442\:0438\:043a\:0430\:043b\:044c\:043d\:043e\:0439 \:043f\:0440\:043e\:0440\:0438\:0441\:043e\:0432\:043a\:0438 \:0440\:0435\:0431\:0435\:0440 \:0440\:0430\:0437\:043d\:043e\:0433\:043e \:0442\:0438\:043f\:0430";

GetCoordinates[args_,OptionsPattern[]]:=Module[
{
\[Delta]w=OptionValue[XDistanceOption],
\[Delta]h=OptionValue[YDistanceOption],
weights=OptionValue[WeightsOption],
arcs=args["graph with dummies"],
layers=args["layers with dummies"],

vertexCount,typeOfArcs,varsOnLayers,varsPenalty,
constraintOrder,constraintPenalty,constraintLowerBound,constraintUpperBound,
f,cons,vars,optimal,
abscissa,ordinate,coords,
a,x
},
If[!Element[\[Delta]h,PositiveReals],
Message[GetCoordinates::option, \[Delta]h]; 
Abort[]];
If[!Element[\[Delta]w,PositiveReals],
Message[GetCoordinates::option, \[Delta]w]; 
Abort[]];
If[!MatchQ[weights,{_?NumberQ,_?NumberQ,_?NumberQ}], Message[GetCoordinates::option2, weights];Abort[]];


vertexCount=Length@Flatten@layers;

typeOfArcs=Total[Boole@Table[{arc[[1]]>=args["first dummy"],arc[[2]]>=args["first dummy"]},{arc,arcs}],{2}]+1;

varsOnLayers=Map[x,layers,{2}];
varsPenalty=a@@@arcs;

constraintOrder=Table[If[Length[layer]>=2,Thread[Subtract@@@Partition[layer,2,1]<=-\[Delta]w],Nothing],{layer,varsOnLayers}];
constraintPenalty=Table[With[{u=arc[[1]],v=arc[[2]]},{x[u]-x[v]<=a[u,v],x[v]-x[u]<=a[u,v]}],{arc,arcs}];
constraintUpperBound=Thread[Flatten[varsOnLayers]<=2*\[Delta]w*vertexCount];
constraintLowerBound=Thread[0<=Flatten[varsOnLayers]];

f=Dot[weights[[typeOfArcs]],varsPenalty];
cons=Flatten@Join[constraintOrder,constraintPenalty,constraintLowerBound,constraintUpperBound];
vars=Flatten@Join[varsOnLayers,varsPenalty];

optimal=LinearOptimization[f,cons,vars,"PrimalMinimizer"];

abscissa=Take[optimal,vertexCount];
ordinate=Flatten@MapThread[ConstantArray,{\[Delta]h*Range@Length@layers,Length/@layers}];

coords=Thread[{abscissa,ordinate}];

<|
"acyclic graph"->args["acyclic graph"],
"feedback set"->args["feedback set"],
"first dummy"->args["first dummy"],
"graph with dummies"->args["graph with dummies"],
"layers with dummies"->args["layers with dummies"],
"coords"->Thread[Flatten[args["layers with dummies"]]->-coords]|>
]


(* ::Chapter:: *)
(*6. MyLayeredGraphPlot - \:0438\:0442\:043e\:0433\:043e\:0432\:0430\:044f \:0444\:0443\:043d\:043a\:0446\:0438\:044f*)


Clear[MyLayeredGraphPlot]
Attributes[MyLayeredGraphPlot]={ReadProtected};
Options[MyLayeredGraphPlot]={ApproachOption->"WM"};
MyLayeredGraphPlot[graph_,opt_, OptionsPattern[]]:=
(
	Module[
		{GetDaGRes,GetLayeringRes,GetAddDummyVerticsRes,GetVertexOrderRes,GetCoordsResult,
		optionsGetDag={"Random Order", "BFS Order","DFS Order","VertexOutDegree Order","Cycle Removal","IP SCF","IP TI"},
		optionsGetLayering={"Longest Path","Exact","Min Width","{Min Width, _Integer, _Integer}"},
		optionsGetLayeringImprovment={True, False},
		optionsAddADummyVertics={"Base", "Cut"},
		optionsGetVertexOrder={"Matheuristic","Barycenter", "{Barycenter,maxNumberOfIterations_Integer?Positive}"},
			result, l, layers,rules,edges,y,arcs,vertices,
			options={"WM", "Naive"},
			approach=OptionValue[ApproachOption]
		},
		If[MemberQ[options, approach]==False,
		Message[MyLayeredGraphPlot::option, approach, StringRiffle[options, "\n","\t"]]; 
		Abort[]];
		If[MemberQ[optionsGetDag, opt["GetDag"]["ApproachOption"]]==False, 
			Message[MyLayeredGraphPlot::option, opt["GetDag"]["ApproachOption"], StringRiffle[optionsGetDag, "\n","\t"]]; Abort[]
		];
		If[((MemberQ[optionsGetLayering, opt["GetLayering"]["ApproachOption"]]) || (MatchQ[opt["GetLayering"]["ApproachOption"],{"Min Width",_?IntegerQ,_?IntegerQ}]))==False, 
			Message[MyLayeredGraphPlot::option, opt["GetLayering"]["ApproachOption"], StringRiffle[optionsGetLayering, "\n","\t"]]; Abort[],
			If[
				MemberQ[optionsGetLayeringImprovment, opt["GetLayering"]["ImprovmentOption"]]==False, 
				Message[MyLayeredGraphPlot::option, opt["GetLayering"]["ImprovmentOption"], StringRiffle[optionsGetLayeringImprovment, "\n","\t"]]; Abort[]
			]
		];
		If[MemberQ[optionsAddADummyVertics, opt["AddDummyVertices"]["ApproachOption"]]==False, 
			Message[MyLayeredGraphPlot::option, opt["AddDummyVertices"]["ApproachOption"], StringRiffle[optionsAddADummyVertics, "\n","\t"]]; Abort[]
		];
		If[((MemberQ[optionsGetVertexOrder, opt["GetVertexOrder"]["ApproachOption"]]) || (MatchQ[opt["GetVertexOrder"]["ApproachOption"],{"Barycenter",_?IntegerQ}]))==False, 
			Message[MyLayeredGraphPlot::option, opt["GetVertexOrder"]["ApproachOption"], StringRiffle[optionsGetVertexOrder, "\n","\t"]]; Abort[]
		];
		If[Element[opt["GetCoordinates"]["XDistanceOption"],PositiveReals]==False, Message[GetCoordinates::option, opt["GetCoordinates"]["XDistanceOption"]]; Abort[]];
		If[Element[opt["GetCoordinates"]["YDistanceOption"],PositiveReals]==False, Message[GetCoordinates::option, opt["GetCoordinates"]["YDistanceOption"]]; Abort[]];
		If[MatchQ[opt["GetCoordinates"]["WeightsOption"],{_?IntegerQ,_?IntegerQ,_?IntegerQ}]==False, Message[GetCoordinates::option2, opt["GetCoordinates"]["WeightsOption"]];Abort[]];
		GetDaGRes=GetDAG[graph,ApproachOption->opt["GetDag"]["ApproachOption"]];
		Print["Done GetDag"];
		GetLayeringRes=GetLayering[GetDaGRes,ApproachOption -> opt["GetLayering"]["ApproachOption"], ImprovmentOption -> opt["GetLayering"]["ImprovmentOption"]];
		Print["Done GetLayering"];
		GetAddDummyVerticsRes=AddDummyVertices[GetLayeringRes, ApproachOption->opt["AddDummyVertices"]["ApproachOption"]];
		Print["Done GetAddDummyVertics"];
		GetVertexOrderRes=GetVertexOrder[GetAddDummyVerticsRes, ApproachOption->opt["GetVertexOrder"]["ApproachOption"]];
		Print["Done GetVertexOrder"];
		GetCoordsResult=GetCoordinates[GetVertexOrderRes,XDistanceOption->opt["GetCoordinates"]["XDistanceOption"],
		YDistanceOption->opt["GetCoordinates"]["YDistanceOption"],
		WeightsOption->opt["GetCoordinates"]["WeightsOption"]];
		Print["Done GetCoords"];
		vertices=GroupBy[Flatten@GetCoordsResult["layers with dummies"],#<GetCoordsResult["first dummy"]&];
		Which[approach==="WM",
		 result=Graph[Graph[GetCoordsResult["graph with dummies"],VertexLabels->"Name", VertexCoordinates->GetCoordsResult["coords"]]],
		approach==="Naive", 
		result=Graph[Graph[GetCoordsResult["graph with dummies"],
		VertexLabels->Thread[vertices[True]->vertices[True]],
		ImageSize->Medium, VertexCoordinates->GetCoordsResult["coords"],
		VertexSize->Thread[vertices[False]->0],
		VertexShapeFunction-> "Triangle",
		VertexStyle->Red,
		EdgeStyle->Black]]
		];
		result
		
	]
)


(* ::Chapter:: *)
(*End *)


End[]


EndPackage[]
