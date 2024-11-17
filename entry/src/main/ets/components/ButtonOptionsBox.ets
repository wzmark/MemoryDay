import router from '@ohos.router';


@Component

export struct ButtonOptionBox{
        @Prop nameBox: string;
        @Prop title: string;
        @Prop type: string;
        @Prop placeHolder: string;
        @State text:string = ''
        @State date: string | Date = ''
        private selectedDate: Date = new Date('2021-08-08')

        build() {
                Row(){
                        Text(this.title)
                                .fontSize(20)
                                .fontWeight(FontWeight.Bold).flexGrow(1)
                        if(this.type === "text"){
                                TextInput({text: this.text, placeholder: this.placeHolder})
                                        .width("60%").flexGrow(1)
                        }else if(this.type === "date"){
                                Text(this.selectedDate.toString()).fontSize(10)
                                        .fontWeight(FontWeight.Bold).flexGrow(1)
                                DatePicker({
                                        start: new Date('1900-1-1'),
                                        end: new Date('2100-1-1'),
                                        selected: this.selectedDate
                                }).onChange((value: DatePickerResult) => {
                                        this.selectedDate.setFullYear(value.year as number, value.month as number, value.day as number)
                                        console.info('select current date is: ' + JSON.stringify(value))
                                })
                        }else if(this.type === "option"){

                        }else if(this.type === "switch"){

                        }

                }.justifyContent(FlexAlign.SpaceBetween)


        }
}