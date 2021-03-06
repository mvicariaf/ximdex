// Generated by CoffeeScript 1.10.0
var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ContentTools.FlashUI = (function(superClass) {
  extend(FlashUI, superClass);

  function FlashUI(modifier) {
    FlashUI.__super__.constructor.call(this);
    this.mount(modifier);
  }

  FlashUI.prototype.mount = function(modifier) {
    var monitorForHidden;
    this._domElement = this.constructor.createDiv(['ct-flash', 'ct-flash--active', "ct-flash--" + modifier, 'ct-widget', 'ct-widget--active']);
    FlashUI.__super__.mount.call(this, ContentTools.EditorApp.get().domElement());
    monitorForHidden = (function(_this) {
      return function() {
        if (!window.getComputedStyle) {
          _this.unmount();
          return;
        }
        if (parseFloat(window.getComputedStyle(_this._domElement).opacity) < 0.01) {
          return _this.unmount();
        } else {
          return setTimeout(monitorForHidden, 250);
        }
      };
    })(this);
    return setTimeout(monitorForHidden, 250);
  };

  return FlashUI;

})(ContentTools.AnchoredComponentUI);
