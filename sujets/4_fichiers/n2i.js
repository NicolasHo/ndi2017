var N2I_previewImage = function (event) {
    input = event.target;
    $(input).next('span.n2i_preview').remove();
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $(input).after('<span class="n2i_preview">Aperçu: <img id="preview" class="" /></span>');
            console.log();
            $('#preview').attr('src', e.target.result);
        }

        reader.readAsDataURL(input.files[0]);
    }
}