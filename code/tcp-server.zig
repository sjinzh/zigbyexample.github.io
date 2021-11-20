const std = @import("std");
const net = std.net;

pub fn main() anyerror!void {
    // Initialize local IP address
    // You can also change the port number or use IPv6
    const address = net.Address.initIp4([4]u8{ 127, 0, 0, 1 }, 8080);

    // Initialize server
    // If `reuse_address` is not set to `true`, you should wait after running program
    // For more information read http://unixguide.net/network/socketfaq/4.5.shtml
    var server = net.StreamServer.init(.{ .reuse_address = true });
    defer server.deinit();

    try server.listen(address); // Start listening

    // Accepting incoming connections
    while (true) {
        const conn = try server.accept();
        defer conn.stream.close();

        var buf: [4096]u8 = undefined;
        _ = try conn.stream.read(buf[0..]);

        const message = "HTTP/1.1 200 OK\n\r\nHello world!";
        _ = try conn.stream.write(message);
    }
}
