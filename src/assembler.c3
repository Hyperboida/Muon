module muon::tokenizer @private;
import muon;
import std::collections::list;
import std::ascii;
import std::collections::map;

def List = list::List(<Token>);
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
fn bool Iterator.has_next(&self)
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


enum TokenType
{
    OPCODE,
    LABEL,
    REGISTER,
    LITERAL,
    COMMA,
    LSQ,
    RSQ
}

struct Token 
{
    TokenType type;
    String label;
    Byte opcode;
    short mod;
    Byte size; 
    MuSize register;
}

fn Token create_token(TokenType type, String label = "", Byte opcode = 0, short mod = 0, Byte size = 0, MuSize register = 0)
{
    return Token {type, label, opcode, mod, size, register};

}

fn bool check_label_begin(char a)
{
    return a.is_alpha() || a == '.' || a == '_';
}

fn bool check_label(char a)
{
    return check_label_begin(a) || a == '$';
}
fn void check_string(Iterator iter, List list)
{
    map::HashMap(<String, Byte>) opcodes = muon::get_opcodes();
    map::HashMap(<String, MuSize>) registers = muon::get_registers();
    defer opcodes.free();
    defer registers.free();

    DString out = dstring::temp_new();
    out.append(current);
    while(check_label(current) || current == ':')
    {
        out.append(current);
        if(iter.peek()!! == ':')
        {
           list.push(create_token(LABEL, out.copy_str()));
           out.clear();
           break;
        }
    }
    if(opcodes.has_key(out.str_view()))
    {
        list.push(create_token(OPCODE, .opcode = opcodes[out.str_view()]))!!;
        return;
    }
    if(registers.has_key(out.str_view()))
    {
        list.push(create_token(REGISTER, .register = registers[out.str_view()]))!!;
        return;
    }

}
fn Token[] tokenize(char[] data)
{
    Iterator iter = iterator_init(data);
    char current = iter.get()!!;
    List list;
    list.new_init();
    defer list.free();
        while(iter.has_next())
    {
        if(current.is_space()){ current = iter.next()!!; continue;} //Check Space 
        if(check_label_begin(current)) //Check for label or op
        {
            check_string(iterator, list);
        }

    }
    return list.to_new_array();
}


module muon::assembler;
import muon;
import std::collections::list;

fn char[] assemble(char[] data, Converter conv)
{ 
    list::List(<char>) out;
    out.new_init();
    defer out.free();
    return out.to_new_array();
}

//TODO: Tokenize, Parse, Convert
