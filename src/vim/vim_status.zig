//! The Vim mode status badge floating at the bottom-right of the editor container.

const gooey = @import("gooey");
const theme = @import("../theme.zig");
const AppState = @import("../state.zig").AppState;
const vim = @import("vim.zig");

const ui = gooey.ui;
const Cx = gooey.Cx;

pub const VimStatus = struct {
    pub fn render(_: @This(), cx: *Cx) void {
        const s = cx.state(AppState);

        if (!s.settings.vim_mode) return; // shown if vim mode is enabled.

        //check current vim mode status
        const mode = vim.vim.mode;
        const name = switch (mode) {
            .normal => "NORMAL",
            .insert => "INSERT",
            .visual => "VISUAL",
            .visual_line => "V-LINE",
        };
        const c = theme.color;
        const tag_color = switch (mode) {
            .normal => c.muted,
            .insert => c.primary,
            .visual, .visual_line => c.syntax.keyword,
        };

        cx.render(ui.box(.{
            .height = 20,
            .corner_radius = 4,
            .background = c.background,
            .border_width = .{ .all = 1 },
            .border_color = c.border.withAlpha(0.7),
            .direction = .row,
            .alignment = .{ .cross = .center },
            .padding = .{ .each = .{ .top = 0, .right = 8, .bottom = 0, .left = 8 } },
            .shadow = theme.shadow_xs,
            .floating = .{
                .element_anchor = .right_bottom,
                .parent_anchor = .right_bottom,
                .offset_x = -28,
                .offset_y = -8,
                .z_index = 8,
            },
        }, .{
            ui.text(name, .{
                .size = 11,
                .weight = .bold,
                .color = tag_color,
                .mono = true,
            }),
        }));
    }
};
