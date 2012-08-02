describe("Concept selection", function() {

  describe("when a search term has been entered", function() {

      beforeEach(function() {
        $('#inputNode').val("aids").keyup();
      });

/*
      it("checks a rows checkbox when clicking on the row", function() {

        waitsFor(function(){
            return $('#openmrsSearchTable tbody').is(':contains(aids)');
        }, "Search results should appear", 1000);

        runs(function(){
            $('#openmrsSearchTable tbody tr:eq(0)').click();
            expect($('.conceptSelector').is(":checked")).toBeTruthy();
        });
      });
*/

      it("should copy the row to the selected area when clicking the add selected button", function() {

        waitsFor(function(){
            return $('#openmrsSearchTable tbody').is(':contains(aids)');
        }, "Search results should appear", 1000);

        runs(function(){
            $('#openmrsSearchTable tbody tr:eq(0)').click();
            $('#addSelected').click();
            var rv = $('#conceptsToBeSubmitted').is(":contains(aids)");
            expect(rv).toBe(true);
        });
      });
  });

});
