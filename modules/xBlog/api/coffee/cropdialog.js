// Generated by CoffeeScript 1.10.0
var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ContentTools.CropImageDialog = (function(superClass) {
  extend(CropImageDialog, superClass);

  function CropImageDialog(imageData, file) {
    CropImageDialog.__super__.constructor.call(this, 'Establece la imagen para el post');
    this._state = 'populated';
    this._imageData = imageData;
    this._data = null;
    this._file = file;
    this._state = 'empty';
    if (ContentTools.IMAGE_UPLOADER) {
      ContentTools.IMAGE_UPLOADER(this);
    }
  }

  CropImageDialog.prototype.progress = function(progress) {
    if (progress === void 0) {
      return this._progress;
    }
    this._progress = progress;
    if (!this.isMounted()) {
      return;
    }
    return this._domProgress.style.width = this._progress + "%";
  };

  CropImageDialog.prototype.populate = function(url, size, id) {
    return this.trigger('save', url, id);
  };

  CropImageDialog.prototype.state = function(state) {
    var prevState;
    if (state === void 0) {
      return this._state;
    }
    if (this._state === state) {
      return;
    }
    prevState = this._state;
    this._state = state;
    if (!this.isMounted()) {
      return;
    }
    ContentEdit.addCSSClass(this._domElement, "ct-image-dialog--" + this._state);
    return ContentEdit.removeCSSClass(this._domElement, "ct-image-dialog--" + prevState);
  };

  CropImageDialog.prototype.mount = function() {
    var domActions, domProgressBar, domTools;
    CropImageDialog.__super__.mount.call(this);
    ContentEdit.addCSSClass(this._domElement, 'ct-image-dialog');
    ContentEdit.addCSSClass(this._domElement, 'ct-image-dialog--empty');
    ContentEdit.addCSSClass(this._domView, 'ct-image-dialog__view');
    domTools = this.constructor.createDiv(['ct-control-group', 'ct-control-group--left']);
    this._domControls.appendChild(domTools);
    this._domError = this.constructor.createDiv(['ct-error']);
    this._domError.textContent = ContentEdit._('An error was found, please try again.');
    domTools.appendChild(this._domError);
    domProgressBar = this.constructor.createDiv(['ct-progress-bar']);
    domTools.appendChild(domProgressBar);
    this._domProgress = this.constructor.createDiv(['ct-progress-bar__progress']);
    domProgressBar.appendChild(this._domProgress);
    domActions = this.constructor.createDiv(['ct-control-group', 'ct-control-group--right']);
    this._domControls.appendChild(domActions);
    this._domUpload = this.constructor.createDiv(['ct-control', 'ct-control--text', 'ct-control--upload']);
    this._domUpload.textContent = ContentEdit._('Subir');
    domActions.appendChild(this._domUpload);
    this._domCancelUpload = this.constructor.createDiv(['ct-control', 'ct-control--text', 'ct-control--cancel']);
    this._domCancelUpload.textContent = ContentEdit._('Cancel');
    domActions.appendChild(this._domCancelUpload);
    this._domClear = this.constructor.createDiv(['ct-control', 'ct-control--text', 'ct-control--clear']);
    this._domClear.textContent = ContentEdit._('Clear');
    domActions.appendChild(this._domClear);
    this._img = document.createElement("img");
    this._img.src = this._imageData;
    this._img.classList.add('ct-image-dialog__image');
    this._domView.appendChild(this._img);
    this._addDOMEventListeners();
    return this.trigger('CropImageDialog.mount');
  };

  CropImageDialog.prototype._addDOMEventListeners = function() {
    CropImageDialog.__super__._addDOMEventListeners.call(this);
    this._domUpload.addEventListener('click', (function(_this) {
      return function(ev) {
        return _this.trigger('imageUploader.fileReady', _this._file, _this._data);
      };
    })(this));
    this._domCancelUpload.addEventListener('click', (function(_this) {
      return function(ev) {
        _this.trigger('imageUploader.cancelUpload', false);
        return _this.trigger('cancel');
      };
    })(this));
    return $(this._img).cropper({
      aspectRatio: 3.0 / 4.0,
      scalable: false,
      rotatable: false,
      movable: false,
      viewMode: 1,
      crop: (function(_this) {
        return function(e) {
          _this._data = {
            left: e.x,
            top: e.y,
            width: e.width,
            height: e.height
          };
        };
      })(this)
    });
  };

  return CropImageDialog;

})(ContentTools.DialogUI);
