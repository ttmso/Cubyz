const std = @import("std");
const Allocator = std.mem.Allocator;

const main = @import("root");
const graphics = main.graphics;
const draw = graphics.draw;
const Texture = graphics.Texture;
const vec = main.vec;
const Vec2f = vec.Vec2f;

const gui = @import("../gui.zig");
const GuiComponent = gui.GuiComponent;

const Icon = @This();

const fontSize: f32 = 16;

pos: Vec2f,
size: Vec2f,
texture: Texture,
hasShadow: bool,

pub fn init(pos: Vec2f, size: Vec2f, texture: Texture, hasShadow: bool) Allocator.Error!*Icon {
	const self = try gui.allocator.create(Icon);
	self.* = Icon {
		.texture = texture,
		.pos = pos,
		.size = size,
		.hasShadow = hasShadow,
	};
	return self;
}

pub fn deinit(self: *const Icon) void {
	gui.allocator.destroy(self);
}

pub fn toComponent(self: *Icon) GuiComponent {
	return GuiComponent {
		.icon = self
	};
}

pub fn updateTexture(self: *Icon, newTexture: Texture) !void {
	self.texture = newTexture;
}

pub fn render(self: *Icon, _: Vec2f) !void {
	if(self.hasShadow) {
		draw.setColor(0xff000000);
		self.texture.render(self.pos + Vec2f{1, 1}, self.size);
	}
	draw.setColor(0xffffffff);
	self.texture.render(self.pos, self.size);
}