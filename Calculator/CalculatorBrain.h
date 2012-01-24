//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Harris Jedakis on 12/29/11.
//  Copyright (c) 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void) pushOperand:(double) operand;
-(double) performOperation:(NSString *) operation;
-(void) clearOperandStack;

@end
