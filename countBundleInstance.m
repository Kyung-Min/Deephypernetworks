function countBundleInstance()  
    global content_name;
    tr_ep = 78;
    te_ep_s = 79;
    te_ep_e = 106;

    n_tr_inst = 0;
    n_te_inst = 0;

    %% training data
    count = 0;
    content_name = 'Pororo_ENGLISH2_1';
    count = countInstance(count,'Pororo_ENGLISH2_1_ep1');
    count = countInstance(count,'Pororo_ENGLISH2_1_ep2');
    count = countInstance(count,'Pororo_ENGLISH2_1_ep3');
    count = countInstance(count,'Pororo_ENGLISH2_1_ep4');
    count = countInstance(count,'Pororo_ENGLISH2_1_ep5');
    count = countInstance(count,'Pororo_ENGLISH2_1_ep6');
    count = countInstance(count,'Pororo_ENGLISH2_1_ep7');
    count = countInstance(count,'Pororo_ENGLISH2_1_ep8');
    count = countInstance(count,'Pororo_ENGLISH2_1_ep9');
    count = countInstance(count,'Pororo_ENGLISH2_1_ep10');
    count = countInstance(count,'Pororo_ENGLISH2_1_ep11');
    count = countInstance(count,'Pororo_ENGLISH2_1_ep12');
    count = countInstance(count,'Pororo_ENGLISH2_1_ep13');        

    content_name = 'Pororo_ENGLISH2_2';
    disp('6. run Hypernetwork for each episode');
    count = countInstance(count,'Pororo_ENGLISH2_2_ep1');
    count = countInstance(count,'Pororo_ENGLISH2_2_ep2');
    count = countInstance(count,'Pororo_ENGLISH2_2_ep3');
    count = countInstance(count,'Pororo_ENGLISH2_2_ep4');
    count = countInstance(count,'Pororo_ENGLISH2_2_ep5');
    count = countInstance(count,'Pororo_ENGLISH2_2_ep6');
    count = countInstance(count,'Pororo_ENGLISH2_2_ep7');
    count = countInstance(count,'Pororo_ENGLISH2_2_ep8');
    count = countInstance(count,'Pororo_ENGLISH2_2_ep9');
    count = countInstance(count,'Pororo_ENGLISH2_2_ep10');
    count = countInstance(count,'Pororo_ENGLISH2_2_ep11');
    count = countInstance(count,'Pororo_ENGLISH2_2_ep12');
    count = countInstance(count,'Pororo_ENGLISH2_2_ep13');

    content_name = 'Pororo_ENGLISH2_3';
    count = countInstance(count,'Pororo_ENGLISH2_3_ep1');
    count = countInstance(count,'Pororo_ENGLISH2_3_ep2');
    count = countInstance(count,'Pororo_ENGLISH2_3_ep3');
    count = countInstance(count,'Pororo_ENGLISH2_3_ep4');
    count = countInstance(count,'Pororo_ENGLISH2_3_ep5');
    count = countInstance(count,'Pororo_ENGLISH2_3_ep6');
    count = countInstance(count,'Pororo_ENGLISH2_3_ep7');
    count = countInstance(count,'Pororo_ENGLISH2_3_ep8');
    count = countInstance(count,'Pororo_ENGLISH2_3_ep9');
    count = countInstance(count,'Pororo_ENGLISH2_3_ep10');
    count = countInstance(count,'Pororo_ENGLISH2_3_ep11');
    count = countInstance(count,'Pororo_ENGLISH2_3_ep12');
    count = countInstance(count,'Pororo_ENGLISH2_3_ep13'); 

    content_name = 'Pororo_ENGLISH2_4';
    count = countInstance(count,'Pororo_ENGLISH2_4_ep1');
    count = countInstance(count,'Pororo_ENGLISH2_4_ep2');
    count = countInstance(count,'Pororo_ENGLISH2_4_ep3');
    count = countInstance(count,'Pororo_ENGLISH2_4_ep4');
    count = countInstance(count,'Pororo_ENGLISH2_4_ep5');
    count = countInstance(count,'Pororo_ENGLISH2_4_ep6');
    count = countInstance(count,'Pororo_ENGLISH2_4_ep7');
    count = countInstance(count,'Pororo_ENGLISH2_4_ep8');
    count = countInstance(count,'Pororo_ENGLISH2_4_ep9');
    count = countInstance(count,'Pororo_ENGLISH2_4_ep10');
    count = countInstance(count,'Pororo_ENGLISH2_4_ep11');
    count = countInstance(count,'Pororo_ENGLISH2_4_ep12');
    count = countInstance(count,'Pororo_ENGLISH2_4_ep13'); 

    content_name = 'Pororo_ENGLISH3_1';
    count = countInstance(count,'Pororo_ENGLISH3_1_ep1');
    count = countInstance(count,'Pororo_ENGLISH3_1_ep2');
    count = countInstance(count,'Pororo_ENGLISH3_1_ep3');
    count = countInstance(count,'Pororo_ENGLISH3_1_ep4');
    count = countInstance(count,'Pororo_ENGLISH3_1_ep5');
    count = countInstance(count,'Pororo_ENGLISH3_1_ep6');
    count = countInstance(count,'Pororo_ENGLISH3_1_ep7');
    count = countInstance(count,'Pororo_ENGLISH3_1_ep8');
    count = countInstance(count,'Pororo_ENGLISH3_1_ep9');
    count = countInstance(count,'Pororo_ENGLISH3_1_ep10');
    count = countInstance(count,'Pororo_ENGLISH3_1_ep11');
    count = countInstance(count,'Pororo_ENGLISH3_1_ep12');
    count = countInstance(count,'Pororo_ENGLISH3_1_ep13'); 
    % 
    content_name = 'Pororo_ENGLISH3_2';
    count = countInstance(count,'Pororo_ENGLISH3_2_ep1');
    count = countInstance(count,'Pororo_ENGLISH3_2_ep2');
    count = countInstance(count,'Pororo_ENGLISH3_2_ep3');
    count = countInstance(count,'Pororo_ENGLISH3_2_ep4');
    count = countInstance(count,'Pororo_ENGLISH3_2_ep5');
    count = countInstance(count,'Pororo_ENGLISH3_2_ep6');
    count = countInstance(count,'Pororo_ENGLISH3_2_ep7');
    count = countInstance(count,'Pororo_ENGLISH3_2_ep8');
    count = countInstance(count,'Pororo_ENGLISH3_2_ep9');
    count = countInstance(count,'Pororo_ENGLISH3_2_ep10');
    count = countInstance(count,'Pororo_ENGLISH3_2_ep11');
    count = countInstance(count,'Pororo_ENGLISH3_2_ep12');
    count = countInstance(count,'Pororo_ENGLISH3_2_ep13'); 

    n_tr_inst = count;
    %% test data
    count = 0;
    content_name = 'Pororo_ENGLISH3_3';
    count = countInstance(count,'Pororo_ENGLISH3_3_ep1');
    count = countInstance(count,'Pororo_ENGLISH3_3_ep2');
    count = countInstance(count,'Pororo_ENGLISH3_3_ep3');
    count = countInstance(count,'Pororo_ENGLISH3_3_ep4');
    count = countInstance(count,'Pororo_ENGLISH3_3_ep5');
    count = countInstance(count,'Pororo_ENGLISH3_3_ep6');
    count = countInstance(count,'Pororo_ENGLISH3_3_ep7');
    count = countInstance(count,'Pororo_ENGLISH3_3_ep8');
    count = countInstance(count,'Pororo_ENGLISH3_3_ep9');
    count = countInstance(count,'Pororo_ENGLISH3_3_ep10');
    count = countInstance(count,'Pororo_ENGLISH3_3_ep11');
    count = countInstance(count,'Pororo_ENGLISH3_3_ep12');
    count = countInstance(count,'Pororo_ENGLISH3_3_ep13'); 

    content_name = 'Pororo_ENGLISH3_4';
    count = countInstance(count,'Pororo_ENGLISH3_4_ep1');
    count = countInstance(count,'Pororo_ENGLISH3_4_ep2');
    count = countInstance(count,'Pororo_ENGLISH3_4_ep3');
    count = countInstance(count,'Pororo_ENGLISH3_4_ep4');
    count = countInstance(count,'Pororo_ENGLISH3_4_ep5');
    count = countInstance(count,'Pororo_ENGLISH3_4_ep6');
    count = countInstance(count,'Pororo_ENGLISH3_4_ep7');
    count = countInstance(count,'Pororo_ENGLISH3_4_ep8');
    count = countInstance(count,'Pororo_ENGLISH3_4_ep9');
    count = countInstance(count,'Pororo_ENGLISH3_4_ep10');
    count = countInstance(count,'Pororo_ENGLISH3_4_ep11');
    count = countInstance(count,'Pororo_ENGLISH3_4_ep12');
    count = countInstance(count,'Pororo_ENGLISH3_4_ep13'); 
    n_te_inst = count;
    fprintf('tr: %d, te: %d\n', n_tr_inst, n_te_inst);
end

function count = countInstance(count,ep_name)
    run 'configure'
    global content_name;
    load([bundle_path '/' content_name '/bundle_' ep_name '.mat']);
    count = count + size(bundle, 1);
end
