/* -- plans for movimentation  -- */

fence_obstacle(no).

/* -- useful rules */ 

// find a free random location
random_pos(X,Y) :- 
    pos(AgX,AgY,_) &
    jia.random(RX,20) &
    jia.random(RY,20) &
    X = (RX-10)+AgX &
    Y = (RY-10)+AgY &
    not jia.obstacle(X,Y) &
    not jia.fence(X,Y) &
    not jia.corral(X,Y).
    
corral_dir_pos(X,Y) :-
	pos(AgX,AgY,_) &
    corral_center(RX, RY) &
    X = RX &
    Y = RY &
    not jia.obstacle(X,Y) &
    not jia.fence(X,Y).
    
cluster_dir_pos(ID,X,Y) :-
	pos(AgX,AgY,_) &
	//jia.cluster(CL, CLaux) &
	jia.getclusters(N,CL,S) &
	N > 0 &
	jia.preferable_cluster(AgX,AgY,L,S,N) &
	
	.list(L) &
	.length(L, A) & A > 0 &
	.print("L: ", L) &
	L = [pos(ClX,ClY)] &
	//.count(play(_,captor,G),NAg) &
	jia.position_to_cluster(ClX,ClY,10, Formation) &
	//Formation = [pos(RX,RY)|TLoc_] &
	.print((ID mod 10)) &
	.print("formaçao: ",Formation) &
	.nth((ID mod 10),Formation,FPos) &
	.print("fpos: ",FPos) &
	set_xy(FPos,X,Y) &
	.print("X: ", X, " Y: ", Y) &
//    X = RX &
//    Y = RY &
    not jia.obstacle(X,Y) &
    not jia.fence(X,Y).
    
set_xy(pos(RX,RY),X,Y) :- 
.print("RX: ", RX, " RY: ", RY) &
X = RX & Y = RY.



/* -- plans to move to a destination represented in the belief target(X,Y) 
   -- (it is a kind of persistent goal)
*/

// if the target is changed, "restart" move
+target(NX,NY)
: .ground(NX) & 
  .ground(NY)
  <- jia.set_target(NX,NY);
     -at_target;
     .print("[goto.asl] Adding/Changing the target to (",NX,",",NY,")!");
     .drop_desire(move);
     !move.
 +target(NX,NY)
 <- .print("Fail to SET TARGET!").

+!move 
   : target(X,Y) & jia.obstacle(X,Y)  // the target is an obstacle! 
  <- .print("[goto.asl] My target ", X, ",", Y, " is an obstacle, ignoring target!");
     -+at_target;
     do(skip);
     !move.
   
/*+!move
   : pos(X,Y,_) & target(X,Y)  // I am at target
  <- -+at_target;
     .print("[goto.asl] I am at target ", X, ",", Y, "!");
     do(skip);
     !move.*/
  
// does one step towards target  
+!move 
   : pos(X,Y,_) & 
     target(BX,BY) & 
     fence_obstacle(FO) &
     jia.direction(X, Y, BX, BY, D, FO) // jia.direction finds one action D (using A*) towards the target
  <- do(D);  // this action will "block" the intention until it is sent to the simulator (in the end of the cycle)
     !move. // continue moving

+!move. 

// in case of failure, move
-!move
  <- .current_intention(I);
     .println("[goto.asl] failure in moving; intention was: ",I);
     !move.

// set fence as obstacle for N cycles
+!fence_as_obstacle(N) : N <= 0
  <- -+fence_obstacle(no).
   
+!fence_as_obstacle(N) : N > 0
  <- -+fence_obstacle(fences);
     .wait( { +pos(_,_,_) } );
     !!fence_as_obstacle(N-1).
       
-!fence_as_obstacle(_) 
  <- -+fence_obstacle(no).
   

