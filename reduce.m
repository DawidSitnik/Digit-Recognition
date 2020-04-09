function rds = reduce(ds, new_class_length)
% Funkcja redukcji liczby pr�bek poszczeg�lnych klas w zbiorze ds
% ds - zbi�r danych do redukcji; pierwsza kolumna zawiera etykiet�
% parts - wierszowy wektor wsp�czynnik�w redukcji dla poszczeg�lnych klas
    %Find indices to elements in first column of A that satisfy the equality
      ind1 = ds(:,1) == 1;
      ind2 = ds(:,1) == 2;
      ind3 = ds(:,1) == 3;
      %Use the logical indices to index into A to return required sub-matrices
      ds1 = ds(ind1,:);
      ds2 = ds(ind2,:);
      ds3 = ds(ind3,:);

    ds = [ds1; ds2; ds3];

	labels = unique(ds(:,1))
    mnew = [];
	
	for i = 1:rows(labels)
		class_df = ds(ds(:,1) == i, :);
        k = randperm(length(class_df));
        mnew = [mnew; class_df(k(1:new_class_length),:)]
	end	

	rds = mnew;
end