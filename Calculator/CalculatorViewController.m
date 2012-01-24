//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Harris Jedakis on 12/29/11.
//  Copyright (c) 2011 -. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic,strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display=_display;
@synthesize brainDisplay = _brainDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber=_userIsInTheMiddleOfEnteringANumber;
@synthesize brain=_brain;


- (CalculatorBrain *) brain
{
    if (!_brain) _brain= [[CalculatorBrain alloc] init];
    return _brain;
}

//method for refreshing the brain label when a new operation is pressed
//it removes the old "=" and places the new one
- (NSString *) refreshBrainDisplayForOperation:(NSString *) string {
    
    NSMutableString * displayString = [NSMutableString stringWithString:string];
    
    //searching to find "=" in the brain label 
    NSCharacterSet * charSet = [NSCharacterSet characterSetWithCharactersInString:@"="];
    NSRange range=[displayString rangeOfCharacterFromSet:charSet];

    //if it has arleady an "=" from a previous operation we clear it
    if (range.location!=NSNotFound) [displayString deleteCharactersInRange:range];
    //if there is no "=" we append it
    
    [displayString appendString:@" = "];
    return displayString;
}

//Action when a digit is pressed
- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString * digit =sender.currentTitle;
    //NSLog(@"digit pressed=%@",digit);
    //if user is entering a number, digits are added at the back
    //else a new number is started
    if (self.userIsInTheMiddleOfEnteringANumber){
    self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber=YES;
    }

}

//Action when . is pressed
- (IBAction)pointPressed {
    //checking if display number has already a point (floating point)
    //this is done to ensure valid floating point numbers
    if (![self.display.text rangeOfString:@"."].length ){
        self.display.text = [self.display.text stringByAppendingString:@"."];
        self.userIsInTheMiddleOfEnteringANumber=YES;
    }
}

//Action when C is pressed
- (IBAction)clearPressed {

    self.display.text=@"0";
    self.brainDisplay.text=@"";
    self.userIsInTheMiddleOfEnteringANumber=NO;
    [self.brain clearOperandStack];
}

//Action when backspace is pressed
- (IBAction)backspacePressed {

    //Range of the last character in display.text
    NSRange lastCharRange;
    lastCharRange.location = self.display.text.length-1;
    lastCharRange.length = 1;
    
    //deleting last character of the string
    if (lastCharRange.location!=0) {
        NSMutableString * displayString = [NSMutableString stringWithString:self.display.text];
        [displayString deleteCharactersInRange:lastCharRange];
        self.display.text =displayString;
        self.userIsInTheMiddleOfEnteringANumber=YES; 
    } else {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber=NO; 
    }
}

//method for changing the sign of the number while user is in the middle of
//entering a number
- (void) changeSign {
    
    double currentNumberOnDisplay = [self.display.text doubleValue];
    NSMutableString *displayString;

        if (currentNumberOnDisplay>0){
            displayString = [NSMutableString stringWithString:@"-"];
            [displayString appendString:self.display.text];
            self.display.text = displayString;
            
        } else if (currentNumberOnDisplay<0){
            displayString = [NSMutableString stringWithString:self.display.text];
            NSRange signRange;
            signRange.location=0;
            signRange.length=1;
            [displayString deleteCharactersInRange:signRange];
            self.display.text =displayString;        
        }
}

//Action when enter is pressed
- (IBAction)enterPressed 
{
    //push operand in the stack
    [self.brain pushOperand:[self.display.text doubleValue ]];
    //show what was sent in the stack in the Brain Display
    self.brainDisplay.text = [self.brainDisplay.text stringByAppendingString:self.display.text];
    self.brainDisplay.text = [self.brainDisplay.text stringByAppendingString:@"  "];
    //user has finished entering the number
    self.userIsInTheMiddleOfEnteringANumber=NO;
}

//Action when an operation is pressed
- (IBAction)operationPressed:(UIButton *)sender {
    //implicit enter if the user hasnt pressed enter
    if ( (self.userIsInTheMiddleOfEnteringANumber) && (![sender.currentTitle isEqualToString:@"+ / -"]) )
        [self enterPressed]; 
    
   //using changeSign method if user is in the middle of entering a number 
    if ( (self.userIsInTheMiddleOfEnteringANumber) && ([sender.currentTitle isEqualToString:@"+ / -"]) )
        [self changeSign];
    else {
        //updating Brain Display with the operation
        self.brainDisplay.text = [self.brainDisplay.text stringByAppendingString:sender.currentTitle];
        //operation is going to occur "=" must be placed in the brain label so we call refreshBrainDisplayForOperation
        self.brainDisplay.text = [self refreshBrainDisplayForOperation:self.brainDisplay.text];
        //accessing the brain (our model) for the operation
        double result = [self.brain performOperation:sender.currentTitle];
        NSString *resultString = [NSString stringWithFormat:@"%g", result];
        self.display.text = resultString;
    }    
}  

- (void)viewDidUnload {
    [self setBrainDisplay:nil];
    [super viewDidUnload];
}
@end
