//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Harris Jedakis on 12/29/11.
//  Copyright (c) 2011 -. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic,strong)  NSMutableArray * operandStack;
@end
 
@implementation CalculatorBrain

@synthesize operandStack=_operandStack;

//the operand Stack of the calculator
- (NSMutableArray *) operandStack
{
    //lazy instatiation
    if (_operandStack ==nil) _operandStack=[[NSMutableArray alloc] init ];
    return _operandStack;
}

-(void) clearOperandStack {
    self.operandStack=nil;
}

-(void) pushOperand:(double) operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

-(double) popOperand
{
    NSNumber * operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

//performing the various operations
-(double) performOperation:(NSString *) operation
{
    double result=0;
    
    if ([operation isEqualToString:@"+"]){
        result=[self popOperand] + [self popOperand];
    } 
    else if ([@"*" isEqualToString:operation] ) {
        result= [self popOperand] * [self popOperand];
  
    }else if ([operation isEqualToString:@"-"]) {
        double subtrahend=[self popOperand];
        result = [self popOperand]-subtrahend;
    }else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    }else if ([operation isEqualToString:@"sin"]) {
        result = sin( [self popOperand] );
 
    }else if ([operation isEqualToString:@"cos"]){
        result = cos( [self popOperand] );
        
    }else if ([operation isEqualToString:@"sqrt"]){
        result = sqrt( [self popOperand] );
    }else if ([operation isEqualToString:@"π"]){
        result = 3.14159265;
    }else if ([operation isEqualToString:@"log"]){
        double number = [self popOperand];
        if (number>0) result = log(number); 
    }else if ([operation isEqualToString:@"+ / -"]){
        double number = [self popOperand];
        if (number!=0) result = - number;
    }
    
    [self pushOperand:result];
    return result;
}
@end
