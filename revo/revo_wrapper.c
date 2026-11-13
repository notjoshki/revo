// Revo - Tiny ncurses wrapper for Ada.
// Copyright (c) 2026 notjoshki

#include <stdio.h>
#include <assert.h>
#include <ncurses.h>

#define MAX_WINDOWS 10

typedef enum {
    INVISIBLE,
    VISIBLE
} Visibility;

typedef enum {
    STANDOUT,
    DIM,
    BLINK,
    UNDERLINE,
    BOLD,
    ITALIC,
    REVERSE
} Attribute;

typedef enum {
    BLACK,
    RED,
    GREEN,
    YELLOW,
    BLUE,
    MAGENTA,
    CYAN,
    WHITE,
    DEFAULT
} Color;

typedef struct {
    unsigned int uid;
    int height;
    int width;
} Window;


static WINDOW *windows[MAX_WINDOWS];
static size_t window_count = 0;

static WINDOW *get_window(const Window *win) {
    if (win == NULL)  return stdscr;
    assert(win->uid >= 0 && win->uid <= MAX_WINDOWS);
    return windows[(size_t)win->uid];
}

int c_getch(Window *win) {
    return wgetch(get_window(win));
}

void c_refresh(Window *win) {
    wrefresh(get_window(win));
}

void c_move(unsigned int y, unsigned int x, Window *win) {
    wmove(get_window(win), y, x);
}

void c_mvprintw(Window *win, unsigned int y, unsigned int x, char *message) {
    mvwaddstr(get_window(win), y, x, message);
}

void c_waddch(Window *win, char c) {
    waddch(get_window(win), c);
}

void c_waddstr(Window *win, char *str) {
    waddstr(get_window(win), str);
}

void cursor_set(Visibility setting) {
    curs_set(setting == VISIBLE);
}

#define SOMETHING_WENT_HELLA_WRONG 999

static unsigned int attribute_to_ncurses(const Attribute attr) {
    switch (attr) {
        case STANDOUT: return A_STANDOUT;
        case DIM: return A_DIM;
        case BLINK: return A_BLINK;
        case UNDERLINE: return A_UNDERLINE;
        case BOLD: return A_BOLD;
        case ITALIC: return A_ITALIC;
        case REVERSE: return A_REVERSE;
        default: return SOMETHING_WENT_HELLA_WRONG;
    }
}

void attribute_on(Attribute attr, Window *win) {
    const int n = attribute_to_ncurses(attr);

    if (n != SOMETHING_WENT_HELLA_WRONG)
        wattron(get_window(win), n);
}

void attribute_off(Attribute attr, Window *win) {
    const int n = attribute_to_ncurses(attr);

    if (n != SOMETHING_WENT_HELLA_WRONG)
        wattroff(get_window(win), n);
}

void c_keypad(Window *win, bool enabled) {
    keypad(get_window(win), enabled ? TRUE : FALSE);
}

static short color_to_ncurses_color(const Color color) {
    switch (color) {
        case BLACK: return COLOR_BLACK;
        case RED: return COLOR_RED;
        case GREEN: return COLOR_GREEN;
        case YELLOW: return COLOR_YELLOW;
        case BLUE: return COLOR_BLUE;
        case MAGENTA: return COLOR_MAGENTA;
        case CYAN: return COLOR_MAGENTA;
        case WHITE: return COLOR_WHITE;
        default: return -1;
    }
}

void c_initialize_color_pair(short pair, Color f, Color b) {
    init_pair(pair, color_to_ncurses_color(f), color_to_ncurses_color(b));
}

void c_color_pair_on(Window *win, short pair) {
    wattron(get_window(win), COLOR_PAIR(pair));
}

void c_color_pair_off(Window *win, short pair) {
    wattroff(get_window(win), COLOR_PAIR(pair));
}

int c_new_window(unsigned int maxy, unsigned int maxx, unsigned int starty, unsigned int startx) {
    assert(window_count + 1 < MAX_WINDOWS);
    windows[window_count] = newwin(maxy, maxx, starty, startx);
    assert(windows[window_count] != NULL);
    return window_count++;
}

void c_delete_window(Window *win) {
    delwin(get_window(win));
}

void c_move_window(Window *win, unsigned int y, unsigned int x) {
    mvwin(get_window(win), y, x);
}

void c_background(Window *win, short pair) {
    wbkgd(get_window(win), COLOR_PAIR(pair));
}

int c_getmaxy() {
    return getmaxy(stdscr);
}

int c_getmaxx() {
    return getmaxx(stdscr);
}

void c_box(Window *win) {
    box(get_window(win), 0, 0);
}
