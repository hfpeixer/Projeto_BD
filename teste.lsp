(vl-load-com)

(defun updateAttribute (blockRef tag valor)
  ;; Atualiza o valor do atributo com base na TAG
  (vl-some
    (function
     '(lambda (att)
        (if (= (strcase (vla-get-TagString att)) (strcase tag))
          (progn
            (setq prefix (if (wcmatch (strcase tag) "*E*") "E=" "N="))
            (setq textoFinal (strcat prefix (rtos valor 2 3))) 
            (vla-put-TextString att textoFinal)
            T
          )
        )
      )
    )
    (vlax-invoke blockRef 'GetAttributes)
  )
)

(defun insertBlockWithAttributes (pt valor tag blockName rotation)

  (defun deg2rad (ang) (* pi (/ ang 180.0)))

  ;; Insere um bloco com atributos em 'pt', rotacionado e preenchido
  (setq modelSpace (vla-get-ModelSpace (vla-get-ActiveDocument (vlax-get-acad-object))))
  (setq blockPath (strcat "E:/TOPOCAD2000V17/" blockName ".dwg"))

  ;; Carrega bloco se necessário
  (if (not (tblsearch "BLOCK" blockName))
    (progn
      (command "_-INSERT" (strcat blockName "=" blockPath) "0,0" "1" "1" "1" "0")
      (command "_ERASE" "L" "") ; apaga inserção temporária
    )
  )

  ;; Insere bloco com rotação
  (setq ptInsert (vlax-3d-point pt))
  (setq blockRef (vla-InsertBlock modelSpace ptInsert blockName 1.0 1.0 1.0 0.0))
  (vla-put-Rotation blockRef (deg2rad Rotation))

  ;; Atualiza atributo com o valor informado
  (updateAttribute blockRef tag (rtos valor 2 3))
)

(defun C:MALHACOORD (/ ent obj intervalo coords minx maxx miny maxy x y linha intPoints start end modelSpace)

 
  ;; Seleção da polilinha fechada
  (princ "\nSelecione uma POLILINHA FECHADA: ")
  (setq ent (car (entsel)))

  (if (and ent
           (member (cdr (assoc 0 (entget ent))) '("LWPOLYLINE" "POLYLINE")))
    (progn
      (setq obj (vlax-ename->vla-object ent))

      ;; Verifica se é fechada
      (if (not (vla-get-Closed obj))
        (progn (princ "\nPolilinha NÃO está fechada.") (exit))
      )

      ;; Solicita intervalo
      (initget 7)
      (setq intervalo (getreal "\nDigite o intervalo da malha (em metros): "))

      ;; Obtém limites da polilinha (bounding box)
      (setq coords (vlax-get obj 'Coordinates))
      (setq minx 1e99 maxx -1e99 miny 1e99 maxy -1e99)
      (repeat (/ (length coords) 2)
        (setq x (car coords)
              y (cadr coords))
        (setq minx (min minx x) maxx (max maxx x))
        (setq miny (min miny y) maxy (max maxy y))
        (setq coords (cddr coords))
      )

      ;; Define o Model Space
      (setq modelSpace (vla-get-ModelSpace (vla-get-ActiveDocument (vlax-get-acad-object))))

      ;; ===== LINHAS VERTICAIS (Easting) =====
      (setq x (* (fix (/ minx intervalo)) intervalo))
      (while (<= x maxx)
        ;; Cria linha vertical para interseção
        (setq linha (vla-addLine modelSpace
                                 (vlax-3d-point (list x miny 0))
                                 (vlax-3d-point (list x maxy 0))))
        (setq intPoints (vlax-invoke obj 'IntersectWith linha acExtendNone))
        (vla-delete linha)

        ;; Desenha linhas verticais e insere blocos nas extremidades
        (if intPoints
          (repeat (/ (length intPoints) 6)
            (setq start (list (nth 0 intPoints) (nth 1 intPoints))
                  end   (list (nth 3 intPoints) (nth 4 intPoints)))

            ;; Desenha a linha da malha
            (entmakex (list '(0 . "LINE")
                            (cons 10 (append start '(0)))
                            (cons 11 (append end '(0)))
                            (cons 62 8))) ; cor cinza escuro

            ;; Insere blocos nas pontas com rotação 0 e valor de EASTING
            (if (< (cadr start) (cadr end))
              (progn
                (insertBlockWithAttributes start x "E-N" "BL-GRADEI" 90.0)
                (insertBlockWithAttributes end x "E-N" "BL-GRADEF" 90.0))
              (progn
                (insertBlockWithAttributes end x "E-N" "BL-GRADEI" 90.0)
                (insertBlockWithAttributes start x "E-N" "BL-GRADEF" 90.0))
            )

            (setq intPoints (cdddr (cdddr intPoints))) ; próximo segmento
          )
        )
        (setq x (+ x intervalo))
      )

      ;; ===== LINHAS HORIZONTAIS (Northing) =====
      (setq y (* (fix (/ miny intervalo)) intervalo))
      (while (<= y maxy)
        ;; Cria linha horizontal para interseção
        (setq linha (vla-addLine modelSpace
                                 (vlax-3d-point (list minx y 0))
                                 (vlax-3d-point (list maxx y 0))))
        (setq intPoints (vlax-invoke obj 'IntersectWith linha acExtendNone))
        (vla-delete linha)

        ;; Desenha linhas horizontais e insere blocos nas extremidades
        (if intPoints
          (repeat (/ (length intPoints) 6)
            (setq start (list (nth 0 intPoints) (nth 1 intPoints))
                  end   (list (nth 3 intPoints) (nth 4 intPoints)))

            ;; Desenha a linha da malha
            (entmakex (list '(0 . "LINE")
                            (cons 10 (append start '(0)))
                            (cons 11 (append end '(0)))
                            (cons 62 8)))

            ;; Insere blocos nas pontas com rotação 90 e valor de NORTHING
            (if (< (car start) (car end))
              (progn
                (insertBlockWithAttributes start y "E-N" "BL-GRADEI" 0.0)
                (insertBlockWithAttributes end y "E-N" "BL-GRADEF" 0.0))
              (progn
                (insertBlockWithAttributes end y "E-N" "BL-GRADEI" 0.0)
                (insertBlockWithAttributes start y "E-N" "BL-GRADEF" 0.0))
            )

            (setq intPoints (cdddr (cdddr intPoints)))
          )
        )
        (setq y (+ y intervalo))
      )

      (princ "\n✅ Malha gerada com blocos e atributos inseridos com sucesso.")
    )
    (princ "\n❌ Entidade inválida. Selecione uma polilinha fechada.")
  )

  (princ)
)
