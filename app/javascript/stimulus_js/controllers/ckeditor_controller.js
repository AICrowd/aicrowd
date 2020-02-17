import { Controller } from 'stimulus';
import ClassicEditor from '@ckeditor/ckeditor5-build-classic';

export default class extends Controller {
    connect() {
        ClassicEditor
            .create( this.element )
            .then( function(editor) {
                editor.plugins.get( 'FileRepository' ).createUploadAdapter = function(loader) { new Adapter( loader ) };
            })
            .catch(function(err) { console.log(err) });
    }
}

// import Base64UploadAdapter from '@ckeditor/ckeditor5-upload/src/adapters/base64uploadadapter';
// https://github.com/ckeditor/ckeditor5-upload/blob/master/src/adapters/base64uploadadapter.js#L56-L108
// https://github.com/ckeditor/ckeditor5-angular/issues/126#issuecomment-551266608
class Adapter {
    constructor( loader ) {
        this.loader = loader;
    }
    upload() {
        return new Promise( function( resolve, reject ) {
            const reader = this.reader = new window.FileReader();

            reader.addEventListener( 'load', function() {
                resolve( { default: reader.result } );
            });

            reader.addEventListener( 'error', function(err) {
                reject( err );
            });

            reader.addEventListener( 'abort', function() {
                reject();
            });

            this.loader.file.then( function(file) {
                reader.readAsDataURL( file );
            });
        } );
    }

    abort() {
        this.reader.abort();
    }
}
