;-----------------------------------
; Get the Instances under the cursor
;-----------------------------------
procedure(jvGetInstUnderCursor(@optional (point nil))
let((instList listLegth n cv)
cv=geGetWindowCellView()

unless(point point=hiGetPoint(hiGetCurrentWindow()))
instList=leSearchHierarchy(cv list(point point) 32 "inst" nil)

; Remove Duplication  
instList=myUniqueList(instList)

if(instList
        then

         listLegth = length( instList )

         for( n 1 listLegth
           instancesList=append1(instancesList nthelem( n instList~>cellName ))
            )
        else printf("Nothing found under the cursor/at given point")
        )
    ; Remove Duplications
    instancesList=myUniqueList(instancesList)
    printf("Detected Instances: %N\n" instancesList)
    selectiveEIPApp()
))


;---------------------------
; Remove List's Duplications
;---------------------------
procedure(myUniqueList(aList)
    let((uTable newList)
        uTable = makeTable("uTable" nil)
        foreach(element aList
            unless(uTable[element]
                newList = cons(element newList)
                uTable[element] = t
            )
        )
        reverse(newList)
    )
)


;--------------------
; Creating the form
;--------------------
procedure( createSelectiveEIPForm()
   let( (viewInsts viewNameR selectEIP)

     viewNameR=hiCreateStringField(
                ?name 'viewNameR
                ?prompt "CellView Name"
                ?value ""
                ?callback ""
                )

     selectEIP = hiCreateButton(
        ?name           'selectEIP
        ?buttonText     "EIP"
        ?callback       leEditInPlace(hiGetCurrentWindow() list(list(dbFindAnyInstByName(geGetEditCellView() car(selectiveEIPForm->viewInsts->value)) 0 0 0)))
                )


     viewInsts = hiCreateListBoxField(
          ?name    'viewInsts
          ?choices instancesList
          ?multipleSelect nil
                        )

      hiCreateAppForm(
         ?name 'selectiveEIPForm
         ?formTitle "Selective EIP"
         ?fields list(
                    list(viewNameR 0:5 400:30 200)
                    list(viewInsts 0:35 400:80 200)
                    list(selectEIP 0:90 100:30 200)
                     )
         ?callback ""
         ?initialSize list(450 450)
      ) ;hiCreateAppForm

      hiDisplayForm('selectiveEIPForm)

   ) ;let
) ;procedure


;-------------
; Entry point
;-------------
procedure(selectiveEIPApp()
    unless(boundp('selectiveEIPForm)
        createSelectiveEIPForm()
        )
    hiDisplayForm(selectiveEIPForm)
    )

