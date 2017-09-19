
library(DiagrammeR)

grViz("
      digraph boxes_and_circles {
      
      # a 'graph' statement
      graph [overlap = true, fontsize = 10, compound=true, Final_modelsep=1, nodesep = 1]
      
      subgraph cluster_0 {
      
      color=black;
      node [style=filled];
      data;
      label = 'Full Data Set';
      }
      
      subgraph cluster_1 {
      
      color=green;
      node [style=filled];
      model_A -> AB_spread model_B->AB_spread;
      label = 'AB Model';
      }

      
      #class_model->Final_model
      
      // Edges that directly connect one cluster to another
      'data' -> 'model_A' [ltail=cluster_0 lhead=cluster_1];
      }
      ")


grViz("
      digraph boxes_and_circles {
      
      # a 'graph' statement
      graph [overlap = true, fontsize = 10, compound=true, Final_modelsep=10, nodesep = .5]
      
      subgraph cluster_0 {
      
      color=black;
      node [style=filled];
      data;
      label = 'Full Data Set';
      }
      
      subgraph cluster_1 {
      
      color=green;
      node [style=filled];
      model_A -> AB_spread model_B->AB_spread;
      label = 'first model';
      }
      
      subgraph cluster_2 {
      
      color=red;
      node [style=filled];
      model_d->cd_spread model_c->cd_spread;
      label = 'second Model';
      }
      
      subgraph cluster_3 {
      
      color=blue;
      node [style=filled];
      model_f->ef_spread model_e->ef_spread;
      label = 'another Model';
      }
      
      subgraph cluster_4 {
      
      color=orange;
      node [style=filled];
      class_model;
      label = 'Classification Model';
      }
      
      subgraph cluster_5 {
      
      color=yellow;
      node [style=filled];
      Final_model;
      label = 'Final_model';
      }
      
      
      # several 'node' statements
      node [shape = box,
      fontname = Helvetica]
      model_A; model_B; AB_spread;
      model_c; model_d; cd_spread;
      model_e; model_f; ef_spread;
      class_model; Final_model
      
      
      node [shape = circle,
      fixedsize = true,
      width = 0.9] // sets as circles
      data
      
      
      
      #class_model->Final_model
      
      // Edges that directly connect one cluster to another
      'data' -> 'model_A' [ltail=cluster_0 lhead=cluster_1];
      'data' -> 'model_c' [ltail=cluster_0 lhead=cluster_2];
      'data' -> 'model_e' [ltail=cluster_0 lhead=cluster_3];
      'data' -> 'class_model' [ltail=cluster_0 lhead=cluster_4];
      'data' -> 'Final_model' [ltail=cluster_0 lhead=cluster_5]
      'model_A' -> 'model_c' [ltail=cluster_1 lhead=cluster_2];
      'model_A' -> 'class_model' [ltail=cluster_1 lhead=cluster_4];
      'model_A' -> 'Final_model' [ltail=cluster_1 lhead=cluster_5]
      'model_c' -> 'model_e' [ltail=cluster_2 lhead=cluster_3];
      'model_c' -> 'class_model' [ltail=cluster_2 lhead=cluster_4];
      'model_c' -> 'Final_model' [ltail=cluster_2 lhead=cluster_5]
      'model_e' -> 'class_model' [ltail=cluster_3 lhead=cluster_4];
      'model_e' -> 'Final_model' [ltail=cluster_3 lhead=cluster_5]
      'class_model' -> 'Final_model' [ltail=cluster_4 lhead=cluster_5]
      
      
      }
      ")

