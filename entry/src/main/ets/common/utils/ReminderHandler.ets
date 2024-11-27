import reminderAgentManager from '@ohos.reminderAgentManager';
import reminderAgent from '@ohos.reminderAgentManager';
import { EventItem } from '../../model/EventModel';
import { BusinessError } from '@kit.BasicServicesKit';


export class ReminderHandler {


        public async addReminder(event: EventItem, reminderTime: number): Promise<number> {
                let reminder = this.initReminder(event, reminderTime);
                console.error(reminder.dateTime.year.toString());

                try {

                } catch (error) {
                        console.error("Failed to publish reminder: " + error.message);

                }
                let reminderId = await reminderAgentManager.publishReminder(reminder);
                console.log("Reminder published successfully, reminderId = " + reminderId);
                return reminderId;
        }

        private initReminder(event: EventItem, reminderTime: number): reminderAgent.ReminderRequestCalendar {
                let title = event.title
                let eventTime = new Date(event.date)
                let content = "已经度过了"
                let reminderRequestCalendar: reminderAgentManager.ReminderRequestCalendar = {
                        dateTime: {year: eventTime.getFullYear(), month: (eventTime.getMonth() + 1), day: (eventTime.getDate()), hour: reminderTime, minute: 0},
                        reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_TIMER,
                        content: content,
                        title: title
                }

                return reminderRequestCalendar;
        }

        public deleteReminder(reminderId: number){
                reminderAgent.cancelReminder(reminderId);
        }

        public updateAllReminders(events: EventItem[], reminderTime: number): Promise<EventItem[]>{
                return new Promise((resolve, reject) => {
                        const promises = events.map(event => {
                                return this.addReminder(event, reminderTime).then(reminderId => {
                                        event.reminderId = reminderId;
                                        return event;
                                })
                        });

                        Promise.all(promises)
                                .then(updatedEvents => {
                                        resolve(updatedEvents);
                                })

                })

        }


}
