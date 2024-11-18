import router from '@ohos.router';
import { OptionsPickerSymbol } from './OptionsPickerSymbol';

export interface Params{
        click: () => void
}

@Component

export struct CustomizedPicker{
        @Prop name: string;
        @Prop title: string;
        @Prop type: string;
        @Prop options: Array<string> = [];
        @Link value: string | Date | boolean;

        @Prop onButtonClick: Params;




        build() {
                Row(){
                        Text(this.title)
                                .fontSize(20)
                                .fontWeight(FontWeight.Bold)
                                .flexGrow(1).fontColor("#ffffff")

                        if(this.type === "date"){
                                Row(){
                                        Text((this.value as Date).getFullYear() + "年"
                                                + ((this.value as Date).getMonth() + 1)
                                                + "月" + (this.value as Date).getDate()+"日")
                                                .fontColor("#ffffff").fontSize(20)
                                        OptionsPickerSymbol()
                                }



                        }else if(this.type === "tag"){
                                Row(){
                                        Text(this.value as string)
                                                .fontSize(20)
                                                .fontWeight(FontWeight.Bold)
                                                .fontColor("#ffffff")
                                        OptionsPickerSymbol()
                                }



                        }else if(this.type === "repeat"){
                                Row(){
                                        Text((this.value as string))
                                                .fontSize(20)
                                                .fontWeight(FontWeight.Bold)
                                                .fontColor("#ffffff")
                                        OptionsPickerSymbol()
                                }

                        }else if(this.type === "format"){
                                Text((this.value as string))
                                        .fontSize(20)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor("#ffffff")
                                OptionsPickerSymbol()
                        } else if(this.type === "remind"){
                                Text(((this.value as string)))
                                        .fontSize(20)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor("#ffffff")
                                OptionsPickerSymbol()
                        }else{
                                OptionsPickerSymbol()
                        }

                }
                .justifyContent(FlexAlign.SpaceAround).alignItems(VerticalAlign.Center)
                .onClick(() => {
                        this.onButtonClick.click()
                }).height("8%")
                .width("90%").border({
                        width: {bottom: "1px"},
                        color: {bottom: Color.White}
                })


        }
}