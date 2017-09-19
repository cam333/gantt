
library(DiagrammeR)



grViz("
      digraph boxes_and_circles {
      
      # a 'graph' statement
      graph [overlap = true, fontsize = 10, compound=true, ranksep=1, nodesep = .5]
      
      subgraph cluster_0 {
      
      color=black;
      node [style=filled];
      #data;
      label = 'Full Data Set';
      }
      
      subgraph cluster_1 {
      
      color=green;
      node [style=filled];
      DA_Energy -> Energy_Spread RT_Energy->Energy_Spread;
      label = 'Energy Model';
      }
      
      subgraph cluster_2 {
      
      color=red;
      node [style=filled];
      RT_Cong->Cong_Spread DA_Cong->Cong_Spread;
      label = 'Congestion Model';
      }
      
      subgraph cluster_3 {
      
      color=blue;
      node [style=filled];
      RT_LMP->LMP_Spread DA_LMP->LMP_Spread;
      label = 'LMP Model';
      }
      
      subgraph cluster_4 {
      
      color=orange;
      node [style=filled];
      Buy_Sell_Class;
      label = 'Buy or Sell Classification Model';
      }
      
      subgraph cluster_5 {
      
      color=yellow;
      node [style=filled];
      Rank;
      label = 'Rank Order Model';
      }
      
      
      # several 'node' statements
      node [shape = box,
      fontname = Helvetica]
      DA_Energy; RT_Energy; Energy_Spread;
      DA_Cong; RT_Cong; Cong_Spread;
      DA_LMP; RT_LMP; LMP_Spread;
      Buy_Sell_Class; Rank
      
      
      node [shape = circle,
      fixedsize = true,
      width = 0.9] // sets as circles
      data
      
      
      
      #Buy_Sell_Class->Rank
      
      // Edges that directly connect one cluster to another
      'data' -> 'DA_Energy' [ltail=cluster_0 lhead=cluster_1];
      'data' -> 'DA_Cong' [ltail=cluster_0 lhead=cluster_2];
      'data' -> 'DA_LMP' [ltail=cluster_0 lhead=cluster_3];
      'data' -> 'Buy_Sell_Class' [ltail=cluster_0 lhead=cluster_4];
      'data' -> 'Rank' [ltail=cluster_0 lhead=cluster_5]
      'DA_Energy' -> 'DA_Cong' [ltail=cluster_1 lhead=cluster_2];
      'DA_Energy' -> 'Buy_Sell_Class' [ltail=cluster_1 lhead=cluster_4];
      'DA_Energy' -> 'Rank' [ltail=cluster_1 lhead=cluster_5]
      'DA_Cong' -> 'DA_LMP' [ltail=cluster_2 lhead=cluster_3];
      'DA_Cong' -> 'Buy_Sell_Class' [ltail=cluster_2 lhead=cluster_4];
      'DA_Cong' -> 'Rank' [ltail=cluster_2 lhead=cluster_5]
      'DA_LMP' -> 'Buy_Sell_Class' [ltail=cluster_3 lhead=cluster_4];
      'DA_LMP' -> 'Rank' [ltail=cluster_3 lhead=cluster_5]
      'Buy_Sell_Class' -> 'Rank' [ltail=cluster_4 lhead=cluster_5]
      
      
      }
      ")

