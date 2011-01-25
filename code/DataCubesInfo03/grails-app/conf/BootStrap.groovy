import org.curransoft.datacubes.Dimension
import org.curransoft.datacubes.Level

class BootStrap {

    def init = { servletContext ->
//        def space = new Dimension(name:'Space').save()
//        def country = new Level(name:'Country').save()
//        space.addToLevels(country);

        new Dimension(name:"Space")
		    .addToLevels(new Level(title:"Country"))
		    .addToLevels(new Level(title:"US State"))
		    .save()
    }
    def destroy = {
    }
}
