module muon;
import std::collections::map;
fn map::HashMap(<String, Byte>) get_opcodes()
{
    char neg = 0b10000000;
    map::HashMap(<String, Byte>) out;
    out.new_init();
    out.set("add",  0x01);
    out.set("addi", 0x01 | neg);
    out.set("addf", 0x02 | neg);
    out.set("sub",  0x03);
    out.set("subi", 0x03 | neg);
    out.set("subf", 0x04 | neg);
    out.set("mul",  0x05);
    out.set("muli", 0x05 | neg);
    out.set("mulf", 0x06 | neg);
    out.set("div",  0x07);
    out.set("divi", 0x07 | neg);
    out.set("divf", 0x08 | neg);
    out.set("inc",  0x09);
    out.set("dec",  0x0a);
    out.set("pow",  0x0b);
    out.set("cmp",  0x0c);
    out.set("jmp",  0x0d);
    out.set("jeq",  0x0f);
    out.set("jnq",  0x10);
    out.set("jg",   0x11);
    out.set("jl",   0x12);
    out.set("jge",  0x13);
    out.set("jle",  0x14);
    out.set("and",  0x15);
    out.set("or",   0x16);
    out.set("xor",  0x17);
    out.set("not",  0x18);
    out.set("lsh",  0x19);
    out.set("rsh",  0x1a);
    out.set("mov",  0x1b);
    out.set("call", 0x1c);
    out.set("pop",  0x1d);
    out.set("lea",  0x1e);
   
    return out;

}
fn map::HashMap(<String, MuSize>) get_registers()
{
    map::HashMap(<String, MuSize>) out;
    out.new_init();
    for(int i = 1; i <= 256; i++)
    {
        out.set(string::new_format("r%d", i), i);
        out.set(string::new_format("a%d", i), i << 8);
        out.set(string::new_format("f%d", i), i << 16);
        out.set(string::new_format("mm%d", i), i << 24);
        
    }
    return out;
}


