/**
 * Variables
 */ 
plateHeight = 12.7; // half an inch in mm
plateLength = 175; // mm
plateWidth = 35; //mm
plateWingLength = 60; //mm
plateWingWidth = 40; //mm
cutOutHeight = 30; //mm
boltSize = 15.5; //mm (hole to fit M14 bolt)
boltXOffset = 50; //m
boltYOffset = 20; //m

mainColor = [0.8, 0.8, 0.8]; // color to use

/**
 * Repeated components
 */
module highResCylinder(height, radius) {
  numberOfCircleSegements = 100;
  cylinder(height, radius, radius, $fn = numberOfCircleSegements);
}

module boltShape() {  
  highResCylinder(cutOutHeight, boltSize / 2);
    
}

/**
 * Single components
 */
// The sections 
module wingPlate() {
  cube([plateWingWidth, plateWingLength, plateHeight]);
}

module plate() {  
  union() {
    cube([plateLength, plateWidth, plateHeight]);    
    translate([0, plateWidth, 0]) {
      wingPlate();
    }
    translate([plateLength - plateWingWidth, plateWidth, 0]) {
      wingPlate();
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

// Circular corner for 90 degree angles
// Note that this circular corner is bigger than the 270 one
module circularCornerShape90() {  
  intersection() {
    difference() {
      translate([-30, -30, 0]) {  
        cube([60, 60, plateHeight]);
      }
      highResCylinder(cutOutHeight, 30);
    }
    translate([-30, -30, 0]) {
      cube([30, 30, cutOutHeight]);
    }
  }
}

module circularCornerShape1() {
  translate([10, 10, 0]) {    
    circularCornerShape270();
  };
}

module circularCornerShape2() {
  translate([plateLength - 10, 10, 0]) {
    rotate([0, 0, 90]) {
      circularCornerShape270();
    }
  };
}

module circularCornerShape3() {
  translate([plateLength - 10, plateWidth + plateWingLength - 10, 0]) {
    rotate([0, 0, 180]) {
      circularCornerShape270();
    }
  };
}

module circularCornerShape4() {
  translate([plateLength - plateWingWidth + 10, plateWidth + plateWingLength - 10, 0]) {
    rotate([0, 0, 270]) {
      circularCornerShape270();
    }
  };
}

module circularCornerShape5() {  
  translate([plateLength - plateWingWidth - 30, plateWidth + 30, 0]) {
    rotate([0, 0, 90]) {
      circularCornerShape90();
    }
  }  
}

module circularCornerShape6() {
  translate([plateWingWidth + 30, plateWidth + 30, 0]) {
    circularCornerShape90();
  }  
}

module circularCornerShape7() {
  translate([plateWingWidth - 10, plateWidth + plateWingLength -10, 0]) {
    rotate([0, 0, 180]) {
      circularCornerShape270();
    }
  };
}

module circularCornerShape8() {
  translate([10, plateWidth + plateWingLength -10, 0]) {
    rotate([0, 0, 270]) {
      circularCornerShape270();
    }
  };
}

module completeShape() {
  color(mainColor) {     
    union() {
      difference() {
        plate();      
        boltShape1();
        boltShape2();
        circularCutOutShape();      
        circularCornerShape1();
        circularCornerShape2();        
        circularCornerShape3();
        circularCornerShape4();
        circularCornerShape7();
        circularCornerShape8();
      }    
      circularCornerShape5();
      circularCornerShape6();
    }
  }
}

/**
 * Main
 */
projection() {  
  completeShape();
}

