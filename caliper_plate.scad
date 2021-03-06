/**
 * Variables
 */ 
plateHeight = 6.35; // half an inch in mm
plateLength = 175; // mm
plateWidth = 90; //mm
cutOutCircleDiameter = 95; //mm
cutOutCircleYPos = (cutOutCircleDiameter / 2) + 35; //mm
yPos = -7; //mm (Y Pod of the entire plate)
plateWingWidth = 40; //mm
cutOutHeight = 30; //mm
boltSize = 15.5; //mm (hole to fit M14 bolt)
boltXOffset = 50; //m
boltYOffset = 20; //m
hubBoltCutOutDiam = 30; //mm

mainColor = [0.8, 0.8, 0.8]; // color to use

/**
 * Repeated components
 */
module highResCylinder(height, radius) {
  numberOfCircleSegements = 100;
  cylinder(height, radius, radius, $fn = numberOfCircleSegements);
}

// Caliper bolt shape
module boltShape() {  
  highResCylinder(cutOutHeight, boltSize / 2);    
}


// Cutout shape to fit a wrench on the hub bolts
module hubBoltCutOut() {  
  highResCylinder(cutOutHeight, hubBoltCutOutDiam / 2);
}


/**
 * Single components
 */
module plate() {   
  difference() {    
    union() {
      translate([0, -7, 0]) {      
        cube([plateLength, plateWidth, plateHeight]);      
      }
      translate([plateLength / 2, cutOutCircleYPos, 0]) {
        highResCylinder(plateHeight, plateLength / 2);
      }
    }    
    translate([plateLength / 2, cutOutCircleYPos, 0]) {
      highResCylinder(cutOutHeight, cutOutCircleDiameter / 2);
    }          
  }  
}

module circularCutOutShape() {   
  translate([plateLength / 2, -45, -10]) {
    highResCylinder(cutOutHeight, 50);        
  }
}

module boltShape1() {
  translate([(plateLength / 2) + boltXOffset, boltYOffset, -10]) {
    boltShape();
  }
}

module boltShape2() {
  translate([(plateLength / 2) - boltXOffset, boltYOffset, -10]) {
    boltShape();
  }
}

module hubBoltCutOutLowerLeft() {
  translate([(plateLength / 2) - 54.5, cutOutCircleYPos - 25, 0]) {  
    hubBoltCutOut();
  }
}

module hubBoltCutOutLowerRight() {
  translate([(plateLength / 2) + 54.5, cutOutCircleYPos - 25, 0]) {  
    hubBoltCutOut();
  }
}

module hubBoltCutOutUpperLeft() {
  translate([(plateLength / 2) - 54.5, cutOutCircleYPos + 25, 0]) {  
    hubBoltCutOut();
  }
}

module hubBoltCutOutUpperRight() {
  translate([(plateLength / 2) + 54.5, cutOutCircleYPos + 25, 0]) {  
    hubBoltCutOut();
  }
}

// Circular corner for 270 degree angles
module circularCornerShape270() {
  intersection() {
    difference() {
      highResCylinder(cutOutHeight, 20);
      highResCylinder(cutOutHeight, 10);
    }
    translate([-20, -20, 0]) {
      cube([20, 20, cutOutHeight]);
    }
  }
}

module circularCornerShape1() {
  translate([10, 10 + yPos, 0]) {    
    circularCornerShape270();
  };
}

module circularCornerShape2() {
  translate([plateLength - 10, 10 + yPos, 0]) {
    rotate([0, 0, 90]) {
      circularCornerShape270();
    }
  };
}

module completeShape() {  
  union() {
    difference() {
      plate();      
      boltShape1();
      boltShape2();
      hubBoltCutOutLowerLeft();
      hubBoltCutOutLowerRight();
      hubBoltCutOutUpperLeft();
      hubBoltCutOutUpperRight();
      circularCutOutShape();      
      circularCornerShape1();
      circularCornerShape2();
    }          
  }    
}

/**
 * Main
 */
projection() {  
  completeShape();
}

