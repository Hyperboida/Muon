module muon::assembler;
import muon;
import std::collections::list;
def List = list::List(<char>);
struct Iterator
{
    usz cursor;
    char[] data;
}

fn Iterator iterator_init(char[] data){
    return Iterator{0, data};
}

fn char! Iterator.get(&self)
{
    if(self.cursor == 0){
        return self.data[0];
    }
    return self.data.len >= self.cursor - 1 ? IteratorResult.NO_MORE_ELEMENT? : self.data[self.cursor - 1];
}
fn bool! Iterator.has_next(&self)
{
    return self.data.len > self.cursor;
}

fn char! Iterator.next(&self)
{
   if(!self.has_next()) return IteratorResult.NO_MORE_ELEMENT?;
   self.cursor++;
   return self.data[self.cursor - 1];
}
fn char! Iterator.peek(&self)
{
    if(!self.has_next()) return IteratorResult.NO_MORE_ELEMENT?;
    return self.data[self.cursor - 1];
}


fn char[] assemble(char[] data, Converter conv)
{ 
    List out;
    out.new_init();
    defer out.free();
    Iterator iter = iterator_init(data);
    while(iter.has_next())
    {
        expr(iter, out);
    }
    return out.to_new_array();
}

//TODO: Tokenize, Parse, Convert
