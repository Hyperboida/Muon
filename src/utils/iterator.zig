
fn Iter(comptime T: type, values: []T) type {
    return struct {
        items: []T = values,
        cursor: usize,

        fn next(self: *Iter) ?*T {
            if (!self.has_next()) return null;
            self.cursor+=1;
            return self.items[self.cursor-1];
        }

        fn peek(self: *Iter) ?*T {
            if (!self.has_next()) return null;
            return self.items[self.cursor];
        }

        fn get(self: *Iter) ?*T {
            return self.items[if (self.cursor == 0) 0 else self.cursor - 1];
        }

        fn has_next(self: *Iter) bool {
            return self.cursor + 1 < self.items.len;
        }

        fn next_if(self: *Iter, pred: fn(*T) bool) ?*T {
            if (self.peek()) |v| {
                if (pred(v)) return self.next();
            }
            return null;
        }
    };
}
