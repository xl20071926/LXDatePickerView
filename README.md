# LXDatePickerView
一款简单日期选择器,使用方便简单.点击弹出日期选择框,选择起始日期会调整结束日期,通过delegate获取选择日期.	
    
    LXDateViewPickerView *pickerView = [[LXDateViewPickerView alloc] initWithFrame:CGRectMake(0, 200.f, self.view.width, 40.f)];
    
    pickerView.delegate = self;
    
    [self.view addSubview:pickerView];
		
![image](Demo.gif)
