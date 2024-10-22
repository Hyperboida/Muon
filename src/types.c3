module muon::types;

def byte = char @builtin;
def Aligned = int128;

macro Aligned register_len(alignment)
{
    return (alignment / 4) * 8;
}

struct Program
{
    Header header;
    Block[] blocks;
}
struct Header
{
    uint version;
    byte alignment;
    uint offset;
}

struct Block
{
    byte major;
    byte minor;
    Aligned length;
    void* data;
}

struct Instr
{
    byte opcode;
    byte mod;
    byte flags;
    Aligned displa;
    Aligned displb;
    byte size;
    Aligned op1;
    Aligned op2;
}
