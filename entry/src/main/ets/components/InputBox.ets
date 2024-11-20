import router from '@ohos.router';

export interface Params{
        change: (value: string | boolean) => void
}

@Component


export struct InputBox{
        @Prop name: string;
        @Prop title: string;
        @Prop type: string;
        @Prop placeHolder: string;
        @Prop onValueChange: Params;
        @Link value : string | boolean;
        @State date: Date = new Date(Date.now());

        aboutToAppear(): void {
                console.error("This value   " + this.value)
        }



        build() {
                Row(){
                        Text(this.title)
                                .fontSize(20)
                                .fontWeight(FontWeight.Bold)
                                .flexGrow(1).fontColor("#ffffff")
                        if(this.type === "text"){
                                TextInput({text: this.value as string, placeholder: this.placeHolder})
                                        .width("60%").flexGrow(1)
                                        .fontColor("#ffffff")
                                        .placeholderColor("#ffffff").textAlign(TextAlign.End)
                                        .placeholderFont({size: 20, weight: FontWeight.Bold})
                                        .onChange((value: string) => {
                                                this.onValueChange.change(value)
                                        })
                        }else if(this.type === "switch"){
                                if((this.value as boolean)){
                                        Toggle({type: ToggleType.Checkbox, isOn: true})
                                                .onChange((isOn: boolean) => {
                                                        this.onValueChange.change(isOn)
                                                })
                                }else{
                                        Toggle({type: ToggleType.Checkbox, isOn: false})
                                                .onChange((isOn: boolean) => {
                                                        this.onValueChange.change(isOn)
                                                })
                                }

                        }

                }.justifyContent(FlexAlign.SpaceBetween).width("90%").border({
                        width: {bottom: "1px"},
                        color: {bottom: Color.White}
                }).height("8%")



        }
}