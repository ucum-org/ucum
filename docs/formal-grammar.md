---
title: Formal Grammar for UCUM
post_excerpt: A short summary to follow.
---


This grammar was created from a parser project employing ANTLR as a
LL(\*) parser generator. Note that this is only one of many ways to
express a formal Grammar for UCUM. Alternatively the grammar could be
written for LR-parser generators (e.g. yacc). Lexer rules have been
omitted for clarity. The objective is to create UCUM-parsers from a
declarative definition of the grammar.

    ucumExpr   :  DIVIDE expr
               |  expr 
               ;
    multiply   :  TIMES term
               |  DIVIDE term
               ;
    expr       :  term (multiply)*  
               ;
    term       :  element (exponent)? (ANN)*
               ;
    element    :  simpleUnit
               |  LPAREN expr RPAREN
               |  ANN
               ;
    exponent   :  (SIGN)? DIGITS    // allow zero exponent?
               ;
    simpleUnit :  prefix metricAtom // prefix is token from lexer
               |  metricAtom  
               |  nonMetricAtom // token from lexer
               |  DIGITS    // allow zero?
               ;
    metricAtom :  baseUnit // token from lexer
               |  derivedMetricAtom // token from lexer
               ;

The following is an original code snippet from a working project using
the ANTLR parser generator:

    //...
    startRule returns [UnitExpr u=null]
        :   u=ucumExpr EOF  // or EOL 
        ;
    
    ucumExpr returns [UnitExpr u=null]
        :   DIVIDE u=expr { u.invert(); }
        |   u=expr 
        ;
    
    multiply[UnitExpr a] returns [UnitExpr u=null]
        :   TIMES u=term { u=a.multiply(u); }
        |   DIVIDE u=term { u.invert(); u=a.multiply(u); }
        ;
        
    expr returns [UnitExpr u=null]
        :   u=term (u=multiply[u])*  
        ;
        
    term returns [UnitExpr u=null]
        { int exp = 1; }
        :   u=element (exp=exponent)? (ANN)* { u.setExponent(exp); }
        ;
    
    element returns [UnitExpr u=null]
        :   u=simpleUnit
        |   LPAREN u=expr RPAREN
        |   ANN                 { u = new UnitExpr();}
        ;
    
    exponent  returns [int exp=1]
        :   (s:SIGN)? e:DIGITS  // allow zero?
            {
                exp = Integer.parseInt(e.getText());
                if(s != null && s.getText().equals("-") ) exp *= -1;
            }
        ;
    
    simpleUnit returns [UnitExpr u=null]
        { double p=0; }
        :   p=prefix u=metricAtom { u.setPrefix(p); } 
        |   u=metricAtom  
        |   u=nonMetricAtom 
        |   d:DIGITS { u = new UnitExpr(Integer.parseInt(d.getText())); }   // allow zero?
        ;
    
    metricAtom returns [UnitExpr u=null]
        :   u=baseUnit 
        |   u=derivedMetricAtom 
        ;
    //... lexer definitions follow
