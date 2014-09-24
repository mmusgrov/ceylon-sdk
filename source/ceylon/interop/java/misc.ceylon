import ceylon.interop.java.internal {
    Util
}

import java.lang {
    JavaString=String,
    Class
}

"The [[java.lang::String]] underling the given Ceylon 
 [[String]]."
shared JavaString javaString(String string) 
        => util.javaString(string);

"A Java [[java.lang::Class]] object representing the given 
 [[Type]]."
shared Class<Type> javaClass<Type>() 
        given Type satisfies Object
        => util.javaClass<Type>();

"A Java [[java.lang::Class]] object representing the 
 concrete type of the given [[instance]]."
shared Class<out Type> javaClassFromInstance<Type>(Type instance) 
        given Type satisfies Object
        => util.javaClassFromInstance(instance);

Util util = Util();
