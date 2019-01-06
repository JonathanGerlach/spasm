module spasm.bindings.mediasource;

import spasm.types;
import spasm.bindings.common;
import spasm.bindings.dom;
import spasm.bindings.html;

enum AppendMode {
  segments,
  sequence
}
enum EndOfStreamError {
  network,
  decode
}
struct MediaSource {
  EventTarget _parent;
  alias _parent this;
  this(JsHandle h) {
    _parent = EventTarget(h);
  }
  auto sourceBuffers() {
    return SourceBufferList(MediaSource_sourceBuffers_Get(this._parent));
  }
  auto activeSourceBuffers() {
    return SourceBufferList(MediaSource_activeSourceBuffers_Get(this._parent));
  }
  auto readyState() {
    return MediaSource_readyState_Get(this._parent);
  }
  auto duration(double duration) {
    MediaSource_duration_Set(this._parent, duration);
  }
  auto duration() {
    return MediaSource_duration_Get(this._parent);
  }
  auto onsourceopen(EventHandler onsourceopen) {
    MediaSource_onsourceopen_Set(this._parent, onsourceopen);
  }
  auto onsourceopen() {
    return MediaSource_onsourceopen_Get(this._parent);
  }
  auto onsourceended(EventHandler onsourceended) {
    MediaSource_onsourceended_Set(this._parent, onsourceended);
  }
  auto onsourceended() {
    return MediaSource_onsourceended_Get(this._parent);
  }
  auto onsourceclose(EventHandler onsourceclose) {
    MediaSource_onsourceclose_Set(this._parent, onsourceclose);
  }
  auto onsourceclose() {
    return MediaSource_onsourceclose_Get(this._parent);
  }
  auto addSourceBuffer(string type) {
    return SourceBuffer(MediaSource_addSourceBuffer(this._parent, type));
  }
  auto removeSourceBuffer(SourceBuffer sourceBuffer) {
    MediaSource_removeSourceBuffer(this._parent, sourceBuffer.handle);
  }
  auto endOfStream(EndOfStreamError error) {
    MediaSource_endOfStream(this._parent, error);
  }
  auto setLiveSeekableRange(double start, double end) {
    MediaSource_setLiveSeekableRange(this._parent, start, end);
  }
  auto clearLiveSeekableRange() {
    MediaSource_clearLiveSeekableRange(this._parent);
  }
  auto isTypeSupported(string type) {
    return MediaSource_isTypeSupported(this._parent, type);
  }
}
enum ReadyState {
  closed,
  open,
  ended
}
struct SourceBuffer {
  EventTarget _parent;
  alias _parent this;
  this(JsHandle h) {
    _parent = EventTarget(h);
  }
  auto mode(AppendMode mode) {
    SourceBuffer_mode_Set(this._parent, mode);
  }
  auto mode() {
    return SourceBuffer_mode_Get(this._parent);
  }
  auto updating() {
    return SourceBuffer_updating_Get(this._parent);
  }
  auto buffered() {
    return TimeRanges(SourceBuffer_buffered_Get(this._parent));
  }
  auto timestampOffset(double timestampOffset) {
    SourceBuffer_timestampOffset_Set(this._parent, timestampOffset);
  }
  auto timestampOffset() {
    return SourceBuffer_timestampOffset_Get(this._parent);
  }
  auto audioTracks() {
    return AudioTrackList(SourceBuffer_audioTracks_Get(this._parent));
  }
  auto videoTracks() {
    return VideoTrackList(SourceBuffer_videoTracks_Get(this._parent));
  }
  auto textTracks() {
    return TextTrackList(SourceBuffer_textTracks_Get(this._parent));
  }
  auto appendWindowStart(double appendWindowStart) {
    SourceBuffer_appendWindowStart_Set(this._parent, appendWindowStart);
  }
  auto appendWindowStart() {
    return SourceBuffer_appendWindowStart_Get(this._parent);
  }
  auto appendWindowEnd(double appendWindowEnd) {
    SourceBuffer_appendWindowEnd_Set(this._parent, appendWindowEnd);
  }
  auto appendWindowEnd() {
    return SourceBuffer_appendWindowEnd_Get(this._parent);
  }
  auto onupdatestart(EventHandler onupdatestart) {
    SourceBuffer_onupdatestart_Set(this._parent, onupdatestart);
  }
  auto onupdatestart() {
    return SourceBuffer_onupdatestart_Get(this._parent);
  }
  auto onupdate(EventHandler onupdate) {
    SourceBuffer_onupdate_Set(this._parent, onupdate);
  }
  auto onupdate() {
    return SourceBuffer_onupdate_Get(this._parent);
  }
  auto onupdateend(EventHandler onupdateend) {
    SourceBuffer_onupdateend_Set(this._parent, onupdateend);
  }
  auto onupdateend() {
    return SourceBuffer_onupdateend_Get(this._parent);
  }
  auto onerror(EventHandler onerror) {
    SourceBuffer_onerror_Set(this._parent, onerror);
  }
  auto onerror() {
    return SourceBuffer_onerror_Get(this._parent);
  }
  auto onabort(EventHandler onabort) {
    SourceBuffer_onabort_Set(this._parent, onabort);
  }
  auto onabort() {
    return SourceBuffer_onabort_Get(this._parent);
  }
  auto appendBuffer(BufferSource data) {
    SourceBuffer_appendBuffer(this._parent, data);
  }
  auto abort() {
    SourceBuffer_abort(this._parent);
  }
  auto remove(double start, double end) {
    SourceBuffer_remove(this._parent, start, end);
  }
}
struct SourceBufferList {
  EventTarget _parent;
  alias _parent this;
  this(JsHandle h) {
    _parent = EventTarget(h);
  }
  auto length() {
    return SourceBufferList_length_Get(this._parent);
  }
  auto onaddsourcebuffer(EventHandler onaddsourcebuffer) {
    SourceBufferList_onaddsourcebuffer_Set(this._parent, onaddsourcebuffer);
  }
  auto onaddsourcebuffer() {
    return SourceBufferList_onaddsourcebuffer_Get(this._parent);
  }
  auto onremovesourcebuffer(EventHandler onremovesourcebuffer) {
    SourceBufferList_onremovesourcebuffer_Set(this._parent, onremovesourcebuffer);
  }
  auto onremovesourcebuffer() {
    return SourceBufferList_onremovesourcebuffer_Get(this._parent);
  }
  auto opIndex(uint index) {
    return SourceBuffer(SourceBufferList_getter__uint(this._parent, index));
  }
  auto opDispatch(uint index)() {
    return SourceBuffer(SourceBufferList_getter__uint(this._parent, index));
  }
}


extern (C) JsHandle MediaSource_sourceBuffers_Get(JsHandle);
extern (C) JsHandle MediaSource_activeSourceBuffers_Get(JsHandle);
extern (C) ReadyState MediaSource_readyState_Get(JsHandle);
extern (C) void MediaSource_duration_Set(JsHandle, double);
extern (C) double MediaSource_duration_Get(JsHandle);
extern (C) void MediaSource_onsourceopen_Set(JsHandle, EventHandler);
extern (C) EventHandler MediaSource_onsourceopen_Get(JsHandle);
extern (C) void MediaSource_onsourceended_Set(JsHandle, EventHandler);
extern (C) EventHandler MediaSource_onsourceended_Get(JsHandle);
extern (C) void MediaSource_onsourceclose_Set(JsHandle, EventHandler);
extern (C) EventHandler MediaSource_onsourceclose_Get(JsHandle);
extern (C) JsHandle MediaSource_addSourceBuffer(JsHandle, string);
extern (C) void MediaSource_removeSourceBuffer(JsHandle, JsHandle);
extern (C) void MediaSource_endOfStream(JsHandle, EndOfStreamError);
extern (C) void MediaSource_setLiveSeekableRange(JsHandle, double, double);
extern (C) void MediaSource_clearLiveSeekableRange(JsHandle);
extern (C) bool MediaSource_isTypeSupported(JsHandle, string);
extern (C) void SourceBuffer_mode_Set(JsHandle, AppendMode);
extern (C) AppendMode SourceBuffer_mode_Get(JsHandle);
extern (C) bool SourceBuffer_updating_Get(JsHandle);
extern (C) JsHandle SourceBuffer_buffered_Get(JsHandle);
extern (C) void SourceBuffer_timestampOffset_Set(JsHandle, double);
extern (C) double SourceBuffer_timestampOffset_Get(JsHandle);
extern (C) JsHandle SourceBuffer_audioTracks_Get(JsHandle);
extern (C) JsHandle SourceBuffer_videoTracks_Get(JsHandle);
extern (C) JsHandle SourceBuffer_textTracks_Get(JsHandle);
extern (C) void SourceBuffer_appendWindowStart_Set(JsHandle, double);
extern (C) double SourceBuffer_appendWindowStart_Get(JsHandle);
extern (C) void SourceBuffer_appendWindowEnd_Set(JsHandle, double);
extern (C) double SourceBuffer_appendWindowEnd_Get(JsHandle);
extern (C) void SourceBuffer_onupdatestart_Set(JsHandle, EventHandler);
extern (C) EventHandler SourceBuffer_onupdatestart_Get(JsHandle);
extern (C) void SourceBuffer_onupdate_Set(JsHandle, EventHandler);
extern (C) EventHandler SourceBuffer_onupdate_Get(JsHandle);
extern (C) void SourceBuffer_onupdateend_Set(JsHandle, EventHandler);
extern (C) EventHandler SourceBuffer_onupdateend_Get(JsHandle);
extern (C) void SourceBuffer_onerror_Set(JsHandle, EventHandler);
extern (C) EventHandler SourceBuffer_onerror_Get(JsHandle);
extern (C) void SourceBuffer_onabort_Set(JsHandle, EventHandler);
extern (C) EventHandler SourceBuffer_onabort_Get(JsHandle);
extern (C) void SourceBuffer_appendBuffer(JsHandle, BufferSource);
extern (C) void SourceBuffer_abort(JsHandle);
extern (C) void SourceBuffer_remove(JsHandle, double, double);
extern (C) uint SourceBufferList_length_Get(JsHandle);
extern (C) void SourceBufferList_onaddsourcebuffer_Set(JsHandle, EventHandler);
extern (C) EventHandler SourceBufferList_onaddsourcebuffer_Get(JsHandle);
extern (C) void SourceBufferList_onremovesourcebuffer_Set(JsHandle, EventHandler);
extern (C) EventHandler SourceBufferList_onremovesourcebuffer_Get(JsHandle);
extern (C) JsHandle SourceBufferList_getter__uint(JsHandle, uint);