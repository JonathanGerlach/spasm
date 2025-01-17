pragma(LDC_no_moduleinfo);
pragma(LDC_no_typeinfo);

import ldc.attributes;

import spasm.types;
import spasm.spa;
import spasm.rt.array;

mixin Spa!App;

enum FilterStyle {
  All,
  Active,
  Completed
}

extern(C) export ubyte* allocString(uint bytes) {
  import spasm.rt.memory;
  void[] raw = allocator.allocate(bytes);
  return cast(ubyte*)raw.ptr;
}

struct App {
  @style!"todoapp" mixin Node!"section";
  @child Header header;
  @child Main main;
  @child Footer footer;
  int count = 0;
  int completed = 0;
  int size = 0;
  FilterStyle filter = FilterStyle.All;
  @visible!"footer" bool showFooter(int size) {
    return size > 0;
  }
  @visible!"main" bool showMain(int size) {
    return size > 0;
  }
  void updateItems() {
    import std.algorithm : count;
    main.update!(main.items);
    this.update.size = main.items.length;
    this.update.count = main.items[].count!(i=>!i.checked);
    this.update.completed = main.items.length - this.count;
  }
  @connect!"main.toggleAll.input.toggle" void toggle() {
    bool checked = main.toggleAll.input.node.getPropertyBool("checked");
    main.toggleEach(checked);
    updateItems();
  }
  @connect!"header.field.enter" void enter() {
    import spasm.rt.memory;
    Item* item = allocator.make!Item;
    item.innerText = header.field.value;
    header.field.update.value = "";
    main.items.put(item);
    updateItems();
  }
  @connect!("main.list.items","view.button.click") void removeItem(size_t idx) {
    main.items.removeItem(idx);
    updateItems();
  }
  @connect!("main.list.items","view.checkbox.toggle") void toggleItem(size_t idx) {
    main.list.items[idx].checked = !main.list.items[idx].checked;
    // TODO: here we need to update data[idx] again, else state in dom is wrong
    updateItems();
  }
  @connect!"footer.filters.all.link.click" void allClick() {
    this.update.filter = FilterStyle.All;
  }
  @connect!"footer.filters.active.link.click" void activeClick() {
    this.update.filter = FilterStyle.Active;
  }
  @connect!"footer.filters.completed.link.click" void completedClick() {
    this.update.filter = FilterStyle.Completed;
  }
  @connect!"footer.clear.click" void clearCompleted() {
    import std.algorithm : remove;
    main.items.removePred!(i => i.checked);
    updateItems();
  }
}

struct Header {
  @style!"header" mixin Node!"header";
  @child Title title;
  @child Input field;
}

struct Title {
  mixin Node!"h1";
  @prop auto innerText = "todos";
}

struct ToggleAll {
  struct Input {
    @style!"toggle-all" mixin Node!"input";
    mixin Slot!"toggle";
    @attr type = "checkbox";
    @prop id = "toggle-all";
    int* count;
    @prop bool checked(int* count) {
      return *count == 0;
    }
    @callback void onChange(Event event) {
      // TODO: would be great if we can add the event.target.checked as second arg
      this.emit(toggle);
    }
  }
  struct Label {
    mixin Node!"label";
    @attr for_ = "toggle-all";
  }
  @child Input input;
  @child Label label;
}

struct Main {
  @style!"main" mixin Node!"section";
  @child ToggleAll toggleAll;
  @style!"todo-list" @child UnorderedList!Item list;
  FilterStyle* filter;
  DynamicArray!(Item*) items;
  auto transform(ref DynamicArray!(Item*) items, FilterStyle* filter) {
    with (FilterStyle) {
      final switch(*filter) {
      case All:
        return items[].update(list);
      case Active:
        import std.algorithm : filter ;
        return items[].filter!(i=>!i.checked).update(list);
      case Completed:
        import std.algorithm : filter ;
        return items[].filter!(i=>i.checked).update(list);
      }
    }
  }
  void toggleEach(bool toggle) {
    foreach(i; items[])
      i.update!(Item.checked)(toggle);
  }
}

struct Footer {
  struct Span {
    @style!"todo-count" mixin Node!"span";
    int* count;
    @prop string innerHTML(int* count) {
      return text("<strong>", *count, "</strong> ", *count > 1 ? "items" : "item", " left");
    }
  }
  struct Filters {
    @style!"filters" mixin Node!"ul";
    @(param.innerText!"All") @child Option all = {option: FilterStyle.All};
    @(param.innerText!"Active") @child Option active = {option: FilterStyle.Active};
    @(param.innerText!"Completed") @child Option completed = {option: FilterStyle.Completed};
  }
  struct Option {
    struct Link {
      mixin Node!"a";
      mixin Slot!"click";
      @attr string href = "#";
      @prop string* innerText;
      FilterStyle* filter;
      FilterStyle* option;
      @style!"selected" bool selected(FilterStyle* filter, FilterStyle* option) {
        return *filter == *option;
      }
      @callback void onClick(MouseEvent event) {
        this.emit(click);
      }
    }
    mixin Node!"li";
    @child Link link;
    FilterStyle option;
  }
  struct Button {
    @style!"clear-completed" mixin Node!"button";
    mixin Slot!"click";
    @prop innerText = "Clear Completed";
    @callback void onClick(MouseEvent event) {
      this.emit(click);
    }
  }
  @style!"footer" mixin Node!"footer";
  @child Span span;
  @child Filters filters;
  @child Button clear;
  int* completed;
  @visible!"clear" bool canClear(int* completed) {
    return *completed > 0;
  }
}

// TODO: we can move some data into an upper state struct (like the todo list), and use an pointer to get a reference to it.

struct Input {
  @style!"new-todo" mixin Node!"input";
  mixin Slot!"enter";
  mixin Slot!"input";
  @prop string value;
  @attr string placeholder = "What needs to be done?";
  @callback void onKeyPress(KeyboardEvent event) {
    value = node.getProperty("value");
    if (event.key == "Enter")
      this.emit(enter);
    this.emit(input);
  }
}

struct Item {
  mixin Node!"li";
  @style!"completed" bool checked = false;
  @style!"editing" bool editing;
  @child View view;
  @child InlineInput editField;
  string innerText;
  @connect!"view.label.click" void onEdit() {
    this.update.editing = true;
    editField.update.value = innerText;
    editField.focus();
  }
  @connect!"editField.enter" void onSubmit() {
    this.update.editing = false;
    this.update.innerText = editField.value;
  }
  @connect!"editField.esc" void onEsc() {
    this.update.editing = false;
  }
}

struct View {
  @style!"view" mixin Node!"div";
  @child Checkbox checkbox;
  @child ClickableLabel label;
  @child Button button;
}

struct InlineInput {
  @style!"edit" mixin Node!"input";
  mixin Slot!"enter";
  mixin Slot!"esc";
  mixin Slot!"input";
  @prop string value;
  @callback void onKeyDown(KeyboardEvent event) {
    value = node.getProperty("value");
    if (event.key == "Enter")
      this.emit(enter);
    else if (event.key == "Escape")
      this.emit(esc);
    else
      this.emit(input);
  }
  @callback void onBlur(Event event) {
    this.emit(enter);
  }
}

struct Button {
  mixin Slot!"click";
  @style!"destroy" mixin Node!"button";
  @callback void onClick(MouseEvent event) {
    this.emit(click);
  }
}

struct ClickableLabel {
  mixin Slot!"click";
  mixin Node!"label";
  @prop string* innerText;
  @callback void onDblClick(MouseEvent event) {
    this.emit(click);
  }
}

struct Label {
  mixin Node!"label";
  @prop string* innerText;
}

struct Checkbox {
  @style!"toggle" mixin Node!"input";
  mixin Slot!"toggle";
  @attr string type = "checkbox";
  @prop bool* checked;
  @callback void onChange(Event event) {
    // TODO: would be great if we can add the event.target.checked as second arg
    this.emit(toggle);
  }
}
