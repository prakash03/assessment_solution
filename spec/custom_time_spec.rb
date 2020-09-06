require 'custom_time'

RSpec.describe CustomTime, '.add_minutes' do

  context 'it validates the given input params' do
    it 'raises an error when input minutes is not an integer' do
      expect { CustomTime.add_minutes(time_input: '3:55 PM', add_minutes: '40sb') }
        .to raise_error CustomTime::InvalidInputError
    end

    it 'raises an error when input time is not parsable' do
      expect { CustomTime.add_minutes(time_input: '3a:55 PM', add_minutes: 40) }
        .to raise_error CustomTime::InvalidInputError
    end

    it 'raises an error when input time is not parsable' do
      expect { CustomTime.add_minutes(time_input: '355 PM', add_minutes: 40) }
        .to raise_error CustomTime::InvalidInputError
    end

    it 'raises an error when input time is not parsable' do
      expect { CustomTime.add_minutes(time_input: ' 3: 55 PM', add_minutes: 40) }
        .to raise_error CustomTime::InvalidInputError
    end

    it 'raises an error when input time does not have a session specified' do
      expect { CustomTime.add_minutes(time_input: '3:55', add_minutes: 40) }
        .to raise_error CustomTime::InvalidInputError
    end

    it 'does not raise an error when valid inputs are provided' do
      expect { CustomTime.add_minutes(time_input: '03:55 AM', add_minutes: 40) }
        .to_not raise_error
    end
  end

  context 'when the input minutes to add is a positive integer' do
    it 'adds the input minutes and updates the minutes' do
      res = CustomTime.add_minutes(time_input: '9:13 AM', add_minutes: 28)
      expect(res).to eq '09:41 AM'
    end

    it 'adds the input minutes and updates hours as well' do
      res = CustomTime.add_minutes(time_input: '10:10 PM', add_minutes: 70)
      expect(res).to eq '11:20 PM'
    end

    it 'adds the input minutes and updates hours, minutes and the session' do
      res = CustomTime.add_minutes(time_input: '11:10 PM', add_minutes: 70)
      expect(res).to eq '00:20 AM'
    end

    it 'adds the input minutes and updates hours, minutes and the session' do
      res = CustomTime.add_minutes(time_input: '11:10 PM', add_minutes: 270)
      expect(res).to eq '03:40 AM'
    end

    it 'adds the input minutes and updates hours, minutes and the session' do
      res = CustomTime.add_minutes(time_input: '11:10 AM', add_minutes: 70)
      expect(res).to eq '12:20 PM'
    end

    it 'adds the input minutes and updates time' do
      res = CustomTime.add_minutes(time_input: '12:15 PM', add_minutes: 20)
      expect(res).to eq '12:35 PM'
    end

    it 'adds the input minutes and updates time' do
      res = CustomTime.add_minutes(time_input: '00:15 AM', add_minutes: 20)
      expect(res).to eq '00:35 AM'
    end

    it 'adds the input minutes and updates time' do
      res = CustomTime.add_minutes(time_input: '00:15 AM', add_minutes: 710)
      expect(res).to eq '12:05 PM'
    end

    context 'when the input minutes sum up to more than 12 hours' do
      it 'adds the input minutes and updates hours, minutes and session' do
        res = CustomTime.add_minutes(time_input: '05:00 AM', add_minutes: 720 + 30)
        expect(res).to eq '05:30 PM'
      end

      it 'adds the input minutes and updates hours, minutes and session' do
        res = CustomTime.add_minutes(time_input: '10:00 AM', add_minutes: 720 + 130)
        expect(res).to eq '00:10 AM'
      end

      it 'adds the input minutes and updates hours, minutes and session' do
        res = CustomTime.add_minutes(time_input: '10:00 PM', add_minutes: 720 + 130)
        expect(res).to eq '12:10 PM'
      end

      it 'adds the input minutes and updates hours, minutes and session' do
        res = CustomTime.add_minutes(time_input: '10:00 AM', add_minutes: 720 + 250)
        expect(res).to eq '02:10 AM'
      end

      it 'adds the input minutes and updates hours, minutes and session' do
        res = CustomTime.add_minutes(time_input: '11:59 PM', add_minutes: 720 + 2)
        expect(res).to eq '12:01 PM'
      end

      it 'adds the input minutes and updates hours, minutes and session' do
        res = CustomTime.add_minutes(time_input: '11:30 PM', add_minutes: 720 + 700)
        expect(res).to eq '11:10 PM'
      end

      it 'add the input minutes and updates hours, minutes and session' do
        res = CustomTime.add_minutes(time_input: '00:15 AM', add_minutes: 740)
        expect(res).to eq '12:35 PM'
      end

      it 'add the input minutes and updates hours, minutes and session' do
        res = CustomTime.add_minutes(time_input: '12:15 PM', add_minutes: 1420)
        expect(res).to eq '11:55 AM'
      end
    end
    
    context 'when the input minutes sum up more than 24 hours' do
      it 'adds the input minutes and updates hours, minutes and session' do
        res = CustomTime.add_minutes(time_input: '5:10 AM', add_minutes: 1450)
        expect(res).to eq '05:20 AM'
      end

      it 'adds the input minutes and updates hours, minutes and session' do
        res = CustomTime.add_minutes(time_input: '10:00 AM', add_minutes: 1440 + 250)
        expect(res).to eq '02:10 PM'
      end

      it 'adds the input minutes and updates hours, minutes and session' do
        res = CustomTime.add_minutes(time_input: '10:00 AM', add_minutes: 103248723483984)
        expect(res).to eq '08:24 PM'
      end
    end
  end

  context 'when the input minutes to add is a negative integer' do
    it 'subtracts the given number of minutes' do
      res = CustomTime.add_minutes(time_input: '1:40 PM', add_minutes: -20)
      expect(res).to eq '01:20 PM'
    end

    it 'subtracts the input minutes and updates the hour' do
      res = CustomTime.add_minutes(time_input: '5:40 PM', add_minutes: -200)
      expect(res).to eq '02:20 PM'
    end

    it 'subtracts the input minutes and updates the hour and session' do
      res = CustomTime.add_minutes(time_input: '1:40 PM', add_minutes: -200)
      expect(res).to eq '10:20 AM'
    end

    it 'subtracts the input minutes and updates the hour and session' do
      res = CustomTime.add_minutes(time_input: '1:40 PM', add_minutes: -50)
      expect(res).to eq '12:50 PM'
    end

    it 'subtracts the input minutes and updates the hour and session' do
      res = CustomTime.add_minutes(time_input: '1:40 AM', add_minutes: -50)
      expect(res).to eq '00:50 AM'
    end

    it 'subtracts the input minutes and updates time' do
      res = CustomTime.add_minutes(time_input: '1:40 AM', add_minutes: -130)
      expect(res).to eq '11:30 PM'
    end

    it 'subtracts the input minutes and updates time' do
      res = CustomTime.add_minutes(time_input: '00:15 AM', add_minutes: -700)
      expect(res).to eq '12:35 PM'
    end

    context 'when input minutes is equal to or greater than 12 hours' do
      it 'subtracts the input minutes and updates time' do
        res = CustomTime.add_minutes(time_input: '00:15 AM', add_minutes: -720)
        expect(res).to eq '12:15 PM'
      end

      it 'subtracts the input minutes and updates time' do
        res = CustomTime.add_minutes(time_input: '01:45 AM', add_minutes: -720)
        expect(res).to eq '01:45 PM'
      end

      it 'subtracts the input minutes and updates time' do
        res = CustomTime.add_minutes(time_input: '00:15 AM', add_minutes: -720)
        expect(res).to eq '12:15 PM'
      end

      it 'subtracts the input minutes and updates time' do
        res = CustomTime.add_minutes(time_input: '1:15 AM', add_minutes: -1420)
        expect(res).to eq '01:35 AM'
      end
    end

    context 'when the input minutes is equal to greater than 24 hours' do
      it 'subtracts the input minutes and updates time' do
        res = CustomTime.add_minutes(time_input: '00:15 AM', add_minutes: -1440)
        expect(res).to eq '00:15 AM'
      end

      it 'subtracts the input minutes and updates time' do
        res = CustomTime.add_minutes(time_input: '12:15 PM', add_minutes: -1440)
        expect(res).to eq '12:15 PM'
      end

      it 'subtracts the input minutes and updates time' do
        res = CustomTime.add_minutes(time_input: '12:15 PM', add_minutes: -1440)
        expect(res).to eq '12:15 PM'
      end

      it 'subtracts the input minutes and updates time' do
        res = CustomTime.add_minutes(time_input: '12:15 PM', add_minutes: -1440-20)
        expect(res).to eq '11:55 AM'
      end

      it 'subtracts the input minutes and updates time' do
        res = CustomTime.add_minutes(time_input: '3:55 PM', add_minutes: -1440-200)
        expect(res).to eq '12:35 PM'
      end
    end
  end
end