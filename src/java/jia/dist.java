package jia;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.NumberTerm;
import jason.asSyntax.NumberTermImpl;
import jason.asSyntax.Term;
import jason.environment.grid.Location;

/**
 * Gets the distance between two points.
 * Use: jia.dist(+IagX,+IagY,+ItoX,+ItoY, -Dist);
 * Where: Dist = dist ((IagX,IagY) , (ItoX,Itoy));
 * @author jomi
 */
public class dist extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] terms) throws Exception {
        int iagx = (int) ((NumberTerm) terms[0]).solve();
        int iagy = (int) ((NumberTerm) terms[1]).solve();
        int itox = (int) ((NumberTerm) terms[2]).solve();
        int itoy = (int) ((NumberTerm) terms[3]).solve();
        int dist = new Location(iagx, iagy).maxBorder(new Location(itox, itoy));
        return un.unifies(terms[4], new NumberTermImpl(dist));
    }
}
