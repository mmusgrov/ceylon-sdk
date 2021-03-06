import java.lang {
    UnsupportedOperationException
}
import java.util {
    JIterator=Iterator
}

"A Java [[java.util::Iterator]] that wraps a Ceylon
 [[Iterator]]. This iterator is unmodifiable, throwing
 [[UnsupportedOperationException]] from [[remove]]."
shared class JavaIterator<T>(Iterator<T> iterator)
        satisfies JIterator<T> {
    
    variable Boolean first = true;
    variable T|Finished item = finished;
    
    shared actual Boolean hasNext() {
        if (first) {
            item = iterator.next();
            first = false;
        }
        return !item is Finished;
    }
    
    shared actual T? next() {
        if (first) {
            item = iterator.next();
            first = false;
        }
        T|Finished olditem = item;
        item = iterator.next();
        if (!is Finished olditem) {
            return olditem;
        } else {
            return null;
        }
    }
    
    shared actual void remove() { 
        throw UnsupportedOperationException("remove()"); 
    }
    
}


