/* -- plans for exploration phase -- */


/*
   -- plans for new match 
   -- create the initial exploration groups and areas 
*/


+gsize(_,_)                             // new match has started 
  <- !!start.

+!start
:
	.my_name(Me) &
	agent_id(Me,My_Id) &
	My_Id == 1 &
	not .intend(start)
<-	
	.print("will create");
	jmoise.create_group(team);
	!!create_grupoDeConducao
.

+!start
:
	.my_name(Me) &
	agent_id(Me,My_Id) &
	My_Id \== 1 &
	not .intend(start)
<-
	if(not group(grupoDeConducao, _)) {
		.print("No Groups");
	    .wait({+pos(_,_,_)});
	    !!start
     } else { 
     	?group(grupoDeConducao,G);    	
     	!change_role(vaqueiroDeBusca,G);
     	.print("Entrei no papel vaqueiroDeBusca");
     };
.

+!create_grupoDeConducao
   : .my_name(Me) &
	 not .intend(grupoDeConducao)
  <-
     .print(grupoDeConducao);
     if( not group(grupoDeConducao,_)[owner(Me)] ) {
	    ?group(team,TeamGroup); // get the team Id
	            .print("trying to create grupoDeBusca:" , TeamGroup);
	    
        jmoise.create_group(grupoDeConducao,TeamGroup,G);
        !broadcast_leader(G,Me);
		.print("[change.asl] grupoDeConducao ",G," created")
     } else {
	    ?group(grupoDeConducao,G)[owner(Me)]
     };
     
     // adopt role explorer in the group
     !change_role(vaqueiroDeBusca,G);
     // create the scheme
     if ( not (scheme(vencerCompeticao,S) & scheme_group(S,G)) ) {
        .print("[change.asl] Creating vencerCompeticao scheme for group ",G);
        -target(_,_); // remove target so that a new one is selected by near unvisited
        jmoise.create_scheme(vencerCompeticao, [G])
     }.

+!broadcast_leader(G,Me)
<- 	+group_leader(G,Me);
	.broadcast(tell, group_leader(G,Me)).

/////////////////
/*
+gsize(_,_)                             // new match has started 
  <- !!start_being_dummy. 


+!start_being_dummy
   : .my_name(Me) &
     agent_id(Me,My_Id) &
     My_Id == 1 &
     not .intend(start_being_dummy)
     <- 
     .print("ME", Me);
     .print("My_Id", My_Id);
     .print("I'm the leader, should create dummy1!");
     jmoise.create_group(team);
     !!create_change_gr1.
        
        
+!start_being_dummy
   : .my_name(Me) &
     agent_id(Me,My_Id) &
     My_Id == 2 &
     not .intend(start_being_dummy)
     <- .print("I'm the leader, should create dummy2!");
          !!create_change_gr2.
     
+!start_being_dummy
   : .my_name(Me) &
     agent_id(Me,My_Id) &
     .findall(L, group_leader(_,L),Agents) &
     .length(Agents, GrNum) &
     GrNum < 2 &
     not .intend(start_being_dummy)
     <- .print("No Groups");
     .wait({+pos(_,_,_)});
       !!start_being_dummy. 
     
       
+!start_being_dummy
   : .my_name(Me) &
     agent_id(Me,My_Id) &
     (My_Id mod 2) == 1 &
     not .intend(start_being_dummy) &
     group(chng1,Gr)
     <- .findall(L, group_leader(_,L),Agents);
      !change_role(change1,Gr);
     .print(L,Agents[0]).
     
+!start_being_dummy
   : .my_name(Me) &
     agent_id(Me,My_Id) &
     (My_Id mod 2) == 0 &
     group(chng2,Gr) &
     not .intend(start_being_dummy)
     <- .findall(L, group_leader(_,L),Agents);
      !change_role(change2,Gr);
     .print(L,Agents[1]).




+!create_change_gr1
   : .my_name(Me) &
	 not .intend(create_change_gr)
  <- // create the exploration group
     .print("trying to create chng1");
     if( not group(chng1,_)[owner(Me)] ) {
	    ?group(team,TeamGroup); // get the team Id
	            .print("trying to create chng1");
	    
        jmoise.create_group(chng1,TeamGroup,G);
        !broadcast_leader(G,Me);
		.print("[change.asl] Chng1 group ",G," created")
     } else {
	    ?group(chng1,G)[owner(Me)]
     };
     
     // adopt role explorer in the group
     !change_role(change1,G);
     
     // create the scheme
     if ( not (scheme(change_scheme1,S) & scheme_group(S,G)) ) {
        .print("[exploration.asl] Creating change scheme for group ",G);
        -target(_,_); // remove target so that a new one is selected by near unvisited
        jmoise.create_scheme(change_scheme1, [G])
     }.
     
+!create_exploration_gr1
<-     .print("no idea");
		.wait({+pos(_,_,_)});
       !!create_exploration_gr1.

+!create_change_gr2
   : .my_name(Me) &
	 not .intend(create_change_gr)
  <- // create the exploration group
     .print("trying to create chng1");
     if( not group(chng2,_)[owner(Me)] ) {
	    ?group(team,TeamGroup); // get the team Id
	            .print("trying to create chng1");
	    
        jmoise.create_group(chng2,TeamGroup,G);
        !broadcast_leader(G,Me);
		.print("[change.asl] Chng1 group ",G," created")
     } else {
	    ?group(chng2,G)[owner(Me)]
     };
     
     // adopt role explorer in the group
     !change_role(change2,G);
     
     // create the scheme
     if ( not (scheme(change_scheme2,S) & scheme_group(S,G)) ) {
        .print("[exploration.asl] Creating change scheme for group ",G);
        -target(_,_); // remove target so that a new one is selected by near unvisited
        jmoise.create_scheme(change_scheme2, [G])
     }.
     
+!create_exploration_gr2
<-     .print("no idea");
		.wait({+pos(_,_,_)});
       !!create_exploration_gr2.


+!broadcast_leader(G,Me)
<- 	+group_leader(G,Me);
	.broadcast(tell, group_leader(G,Me)).

*/
     
{ begin maintenance_goal("+pos(_,_,_)") }

//se tiver um cluster de vacas a vista, cria um cluster ao redor dele.
+!procurarVacas 
: .my_name(Me) &
   agent_id(Me,My_Id) &
	cluster_dir_pos(My_Id,X,Y)
<- 	
    .print("cercando o cluster: ", pos(X,Y), N, CL, SIZES); 
	.print("procurarVacas");
    
   	+target(X,Y).
   	
//caso não tenham vacas a vista, agentes devem se mover aleatóriamentes.
+!procurarVacas 
: random_pos(X,Y)
//corral_dir_pos(X,Y)
<- 	
    .print("direcao aleatoria: ", pos(X,Y)); 
	.print("procurarVacas");
    
   	+target(X,Y).
   	//-procurarVacas;
    //!herding_cows.

+!procurarVacas
<- .print("not going");
   +target(X,Y);
   .
   	
+!herding_cows
	: pos(X,Y,ActionId) & target(TX,TY)
	<-  //.print("[herding_cows1]");
		.drop_desire(move);
		!move.

+!herding_cows : pos(X,Y,ActionId) & target(X,Y).
	//<- 	//.print("[herding_cows2]");
		//.drop_desire(move);
		//!move.

/*
+!herding_cows : target(TX,TY)
	<-	//.print("[herding_cows3]");
		.drop_desire(move);
		!move.
*/

+!herding_cows : pos(X,Y,ActionId) &
	jia.near_least_visited(X,Y,ToX,ToY)
	<- 	//.print("[herding_cows4]");
		!pos(ToX,ToY).

+!herding_cows <- .print("[herding_cows] do nothing").

+!conduzirVacas
<-
	.print("conduzirVacas")
.


+!go_random
:random_pos(X,Y)
<- 	.print("going to: ", pos(X,Y)); 
    
   	+target(X,Y).
   	
+!go_random
<- .print("not going");
   +target(X,Y);
   .

	
/*+!go_random
:random_pos(X,Y)
<- 	.print("going to: ", pos(X,Y)); 
    
   	+target(X,Y).
   
   
+!go_random
<- .print("not going"); 
   +target(X,Y).

*/
+!check_change[scheme(Sch),mission(Mission),group(Gr)]
:  .my_name(Me) &
	jia.random(POR,100)
<- .print("Meu grupo eh",Gr," vou para o outro!");
	//!change_group(Gr,POR)
	.
   

+!check_change
:  .my_name(Me) 
<- .print("nao tenho grupo acho",Gr).

{ end }
	 
	 
+!change_group(_,POR)
:POR > 10 |
 .my_name(gaucho1) |  
 .my_name(gaucho2) 
<- .print("nor changing group").

+!change_group(Gr,_)
: group(chng1,Gr) &
  group(chng2,Gr2) 
<-
.print("Changing to group ",Gr2);  
!change_role(change2,Gr2).

+!change_group(Gr,_)
: group(chng2,Gr) &
  group(chng1,Gr1)
<- !change_role(change1,Gr1).


+!change_group(_,_)
<- .print("       GGG ERRO").