require 'open-uri'
require 'digest/md5'

module Vagrant
  module Downloaders
    # Represents a base class for a downloader. A downloader handles
    # downloading a box file to a temporary file.
    class Base
      include Vagrant::Util

      # The environment which this downloader is operating.
      attr_reader :env

      def initialize(env)
        @env = env
        @retries = 0
      end

      # Called prior to execution so any error checks can be done
      def prepare(source_url)
        @source_filename = File.basename(source_url)
        @md5sums_url = File.join(File.dirname(source_url), 'MD5SUMS')
      end

      # Try to download a file called MD5SUMS for verifying the file download
      def get_md5sum
        begin
          @md5sum = open(@md5sums_url).read.split("\n").find(@source_filename).first.split(' ').first
        rescue
          @md5sum = nil
          # log failure to get md5sums file
        end
      end

      # Downloads the source file to the destination file. It is up to
      # implementors of this class to handle the logic.
      def download!(source_url, destination_file)
        @source_url = source_url
        @destination_file = destination_file
      end


        return if @retries > 3 # only retry 3 times
        @retries += 1

      # Verify download by md5sum
      def verify()
        begin
            file_md5sum = Digest::MD5.file @destination_file # this will take forever
            if !@md5sum.nil? and file_md5sum == @md5sum
                # TODO: log that verification was successful
                return true
            else
                # TODO: log that verification was unsuccessful
                return false
            end
        rescue
            if @md5sum.nil?
                # TODO: log that no verification was possible
                return true
            else
                # TODO: log that 
                return 
            # if md5sum verification caused an error, verify with md5
            # and continue without verification
            return true
        end
      end
    end
  end
end
