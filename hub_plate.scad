/**
 * Variables
 */ 
mainPlateHeight = 12.7; //half an inch in mm
mainPlateDiameter = 175; //mm
hubCutOutDiameter = 94; //mm
cutOutHeight = 30; //mm
hubBoltSize = 13.5; //mm (hole to fit M12 bolt)
hubBoltXOffset = 54.5; //mm
hubBoltYOffset = 25; //mm
pieSliceAngle = 108; //degrees
pieSliceS = 160; //mm (schuine zijde)
lowerRimThickness = 13; //mm

mainColor = [0.8, 0.8, 0.8]; // color to use

/**
 * Repeated components
 */
module highResCylinder(height, radius) {
  numberOfCircleSegements = 100;
  cylinder(height, radius, radius, $fn = numberOfCircleSegements);
}

// Shape of the bolts that hold the hub
module hubBoltShape() {  
  highResCylinder(cutOutHeight, hubBoltSize / 2);
    
}

// length, width, height are the x, y, z dimensions
module prism(l, w, h) {
   polyhedron(
     points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
     faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
   );
}

/**
 * Single components
 */
// The main circular shape where we will cut off the other shapes out of
module mainPlate() {
  highResCylinder(mainPlateHeight, mainPlateDiameter / 2);  
}

// The hole for the hub
module hubCutOutShape() { 
  translate([0, 0, -10]) {
    highResCylinder(cutOutHeight, hubCutOutDiameter / 2);        
  }
}

// The pie slice
module pieSliceShape() {
  pieSliceO = sin(pieSliceAngle / 2) * pieSliceS; // Overstaande zijde
  pieSliceA = cos(pieSliceAngle / 2) * pieSliceS; // Aanliggende zijde
        
  translate([0, -pieSliceA, cutOutHeight - 10]) {
    rotate(a=[0, 90, 90]) {
      union() {
        // Triangle 1
        translate([0, -pieSliceO, 0]) {
          prism(cutOutHeight, pieSliceO, pieSliceA);
        }
        // Triangle 2
        translate([cutOutHeight, pieSliceO, 0]) {
          rotate(a=[0, 0, 180]) {
            prism(cutOutHeight, pieSliceO, pieSliceA);
          }
        }
      }
    }
  }  
}

// The round shape that is cut off the pie on the inside (the bite)
module pieSliceBite() {
  translate([0, 0, -20]) {
    highResCylinder(cutOutHeight + 20, (hubCutOutDiameter / 2) + lowerRimThickness);        
  }
}

// The pie slice with the inner cut out (i.e. pie slice with piece bitten off)
module bittenPieSliceShape() {
  difference() {
    pieSliceShape();
    pieSliceBite();
  }
}

// Little cube that fills a gap in the "bitten pie slice"
module gapFiller() {
  color([1,0,0]) {
    cube([15, 6, mainPlateHeight]);
  }
}

// Left gap filler
module gapFiller1() {  
  translate([-59, -41, 0]) {
    gapFiller();
  }
}

// Right gap filler
module gapFiller2() {  
  translate([44, -41, 0]) {
    gapFiller();
  }
}

// Bolt 1 that holds the hub
module hubBoltShape1() {
  translate([hubBoltXOffset, hubBoltYOffset, 0]) {
    hubBoltShape();
  }
}

// Bolt 2 that holds the hub
module hubBoltShape2() {
  translate([hubBoltXOffset, -hubBoltYOffset, 0]) {
    hubBoltShape();
  }
}

// Bolt 3 that holds the hub
module hubBoltShape3() {
  translate([-hubBoltXOffset, hubBoltYOffset, 0]) {
    hubBoltShape();
  }
}

// Bolt 4 that holds the hub
module hubBoltShape4() {
  translate([-hubBoltXOffset, -hubBoltYOffset, 0]) {
    hubBoltShape();
  }
}

// The complete shape
module completeShape() {  
  union() {
    color(mainColor) {    
      difference() {
        mainPlate();
        hubCutOutShape();
        bittenPieSliceShape();
        hubBoltShape1();                              
        hubBoltShape2();      
        hubBoltShape3();                              
        hubBoltShape4();      
      }
    }
    gapFiller1();
    gapFiller2();
  }
}


/**
 * Main
 */
projection() {
  completeShape();  
}

